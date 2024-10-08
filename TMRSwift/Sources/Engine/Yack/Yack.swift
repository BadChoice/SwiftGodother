import Foundation
import SwiftGodot

class Yack : CompletableAction, ProvidesState {

    var scene:MainScene!
    var currentOptions:[Option]?
    var background = ColorRect()
    var definition:[String:(()->Section)]!
    var finished:(()->Void)?
    
    var wasTouchLocked:Bool = false
    
    var currentOptionLabels:[Label]?
    
    enum Attribute{
        case once, noSpeak
    }
    
    func onTouched(at point:Vector2) {
        let selectedOption = currentOptions?.first { option in
            option.node?.hasPoint(point) ?? false
        }
        
        guard let option = selectedOption else { return }
        option.markAsSelected(yack: self)
        currentOptions?.forEach { $0.node?.removeFromParent() }
        background.removeFromParent()
        
        let afterSpeak = { [unowned self] () -> Void  in
            guard let next = option.next?() else {
                return done()
            }
            show(section: next)
        }
        Game.shared.touchLocked = true
        guard let text = option.speakText else {
            return afterSpeak()
        }
        Sound.play(once: option.sound ?? "maintenance_lighter_\(Int.random(in: 1...3))")
        DeviceVibration.light()
        Say(__(text), expression: option.expression).run {
            afterSpeak()
        }
    }
    
    func onNumberPressed(_ number:Int){
        guard (number - 1) < currentOptionLabels?.count ?? 0 else { return }
        if let label = currentOptionLabels?.reversed()[number - 1] {
            if label.getParent() == nil { return }
            onTouched(at: label.position)
        }
    }
    
    //========================================================
    func run(then:@escaping ()->Void){
        wasTouchLocked = Game.shared.touchLocked
        Game.shared.scene.inventoryUI.toggleNode.run(.fadeOut(withDuration: 0.2))
        Game.shared.scene.hotspots.node.run(.fadeOut(withDuration: 0.2))
        Game.shared.touchLocked = false
        finished = then
        guard let start = start() else {
            return done()
        }
        show(section: start)
    }
    
    func start()  -> Section? { nil }
    func finish() -> Section? { nil }
    
    func done(){
        Game.shared.touchLocked = wasTouchLocked
        restoreUi()
        finished?()
        finished = nil
    }
    
    func restoreUi(){
        Game.shared.scene.inventoryUI.toggleNode.run(.fadeIn(withDuration: 0.2))
        Game.shared.scene.hotspots.node.run(.fadeIn(withDuration: 0.2))
    }
    
    //================================================
    // Sections
    //================================================
    func show(section:Section){
        let afterScript = { [weak self] in
            if let next = section.next?() {
                self?.show(section: next)
                return
            }
            self?.show(options: section.options)
        }
        
        guard let script = section.script else {
            return afterScript()
        }
        
        Script(script) { afterScript() }
    }
    
    //================================================
    // Options
    //================================================
    func show(options:[Option]?){
        guard let options = options else { return done() }
        
        let x:Float = scene.room.camera.getScreenCenterPosition().x - (scene.room.camera.getViewportRect().size.x / 2)
        var y:Float = scene.room.camera.getScreenCenterPosition().y - (scene.room.camera.getViewportRect().size.y / 2)
        
        Game.shared.touchLocked = false
        
        let visibleOptions = options.reversed().filter { shouldShow($0) }
        
        addBackground(visibleOptions.count)
        
        currentOptionLabels = visibleOptions.map {
            let label = labelWith(text: $0.text)
            label.setPosition(Vector2(x:x, y:-y) + Vector2(x:60, y:-80) * Game.shared.scale)
            y += Float(Constants.yackSpacing) * Float(Game.shared.scale)
            $0.node = label
            scene.addChild(node: label)
            return label
        }
        currentOptions = options
    }
    
    func shouldShow(_ option:Option) -> Bool {
        option.shouldBeShown(yack:self)
    }
    
    func labelWith(text:String) -> Label {
        let theLabel = Label()
        theLabel.labelSettings = Label.settings()
        theLabel.text = "● " + __(text)
        theLabel.modulate.alpha     = 0.8
        theLabel.labelSettings?.fontColor = Constants.guyTalkColor
        theLabel.zIndex = Constants.talk_zIndex
        
        return theLabel
    }
    
    fileprivate func addBackground(_ optionsCount: Int) {
        
        background.setSize(Vector2(
            x: scene.room.camera.getViewportRect().size.x - (60 * Float(Game.shared.scale)),
            y: (((Float(optionsCount) + 1.5) * Constants.yackSpacing) - 40) * Float(Game.shared.scale)
        ))
        
        background.setPosition(Vector2(
            x: scene.room.camera.getScreenCenterPosition().x - (scene.room.camera.getViewportRect().size.x / 2) ,
            y: scene.room.camera.getScreenCenterPosition().y + (scene.room.camera.getViewportRect().size.y / 2) - background.getSize().y
        ))
        
        background.color            = .black
        background.modulate.alpha   = Constants.talkBackgroundAlpha
        background.zIndex           = Constants.talk_zIndex - 1
        
        /*background = SKShapshakeeNode(
            rect: CGRect(
                origin: CGPoint(x: -scene.size.width / 2, y: -scene.size.height/2),
                size: CGSize(width: scene.size.width, height: CGFloat((Double(optionsCount) + 1.5) * Double(Constants.yackSpacing)))
            ).insetBy(dx: 16, dy: 16),
            cornerRadius: 14
        )*/

        scene.addChild(node: background)
    }
    
    func onMouseMoved(at point:Vector2){
        currentOptionLabels?.forEach { $0.modulate.alpha = 0.7 }
        let label = currentOptionLabels?.first { $0.hasPoint(point) }
        if label != nil {
            label?.modulate.alpha = 1
            label?.shake()
        }
    }
}

