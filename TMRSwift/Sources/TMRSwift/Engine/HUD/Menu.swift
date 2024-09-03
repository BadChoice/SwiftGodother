import SwiftGodot

class Menu {
    let icon:Sprite2D!
    let node = Node()
    let background = ColorRect()
    
    var isShowing:Bool = false
    
    var options:[Option]!
    var currentOption:Option?
        
    init(){
        
        icon = Sprite2D(path: "res://assets/ui/settings.png")
        
        node.addChild(node: icon)
        icon.zIndex = Constants.menu_zIndex
        
        setupOptions()
    }
    
    func setupOptions(){
        options = [
            CloseMenuOption(),
            //HowToPlayOption(),
            SaveGameOption(),
            ChangeLanguageOption(),
            TextSpeedOption(),
            //MusicOption(),
            //HardModeOption(),
            LoadGameOption(),
            //QuitOption(),
        ]
    }
    
    func onTouched(at point:Vector2) -> Bool {
        if isShowing {
            onOptionPressed(at: point)
            return true
        }
        if icon.hasPoint(point){
            show()
            return true
        }
        return false
    }
    
    func show(){
        Sound.play(once: "tutorial_appear")
        isShowing = true
        
        background.zIndex = Constants.menu_zIndex + 1
        background.color = .black
        
        background.setSize(Game.shared.room.camera.getViewportRect().size)
        background.setPosition(Game.shared.room.camera.getViewportRect().size * -0.5 + Game.shared.room.camera.getScreenCenterPosition())
        
        background.modulate.alpha = 0
        node.addChild(node: background)
        background.run(
            .fadeAlpha(to: 0.8, duration: 0.2)
        )
        
        //let x = icon.position.x + (15 * Float(Game.shared.scale))
        //var y = icon.position.y + (55 * Float(Game.shared.scale))
        let x:Float = Game.shared.room.camera.getViewportRect().size.x - 60 * Float(Game.shared.scale)
        var y:Float = 48 * Float(Game.shared.scale)
        
        options.forEach {
            $0.label.text      = __($0.text)
            $0.label.setPosition(Vector2(x:x, y:y))
            
            if $0.label.getParent() == nil {
                //$0.label.zIndex = Constants.menu_zIndex + 2
                background.addChild(node: $0.label)
            }
            y += /*isPhone ? 100 :*/ 85 * Float(Game.shared.scale)
        }
        
        //icon.run(.rotate(byAngle: 180, duration: 0.2))
    }
    
    func hide(){
        currentOption = nil
        Sound.play(once: "tutorial_disappear")
        isShowing = false
        //icon.run(.rotate(byAngle: -180, duration: 0.2))
        background.run(
            .fadeAlpha(to: 0, duration: 0.2)
        ){ [weak self] in
            self?.background.removeFromParent()
        }
        /*options.forEach { option in
            option.label.run(.fadeOut(withDuration: 0.2))
        }*/
    }
    
    func onOptionPressed(at point: Vector2) {
        
        let localPoint = background.getLocalMousePosition()
        
        if let current = currentOption {
            if current.touched(at: localPoint) { hide() }
            return
        }
        
        let touchedOption = options.first {
            $0.label.hasPoint(localPoint)
        }
        if let touchedOption {
            currentOption = touchedOption
            touchedOption.perform(background)
        } else {
            hide()
        }
    }
    
    func reposition(room:Room){
        guard room.camera.enabled else { return }
        icon.position = Vector2(
            x:room.camera.getScreenCenterPosition().x + (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y - (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: -90, y: 70) * Game.shared.scale
    }
}
