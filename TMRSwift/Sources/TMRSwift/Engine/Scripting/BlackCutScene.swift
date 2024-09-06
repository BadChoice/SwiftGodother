import Foundation
import SwiftGodot

class BlackCutScene : CompletableAction {
    
    var texts:[String]
    let fadingIn:Bool
    let black = ColorRect()
    let label = Label()
    let FADE_DURATION = 0.5
    let TEXT_DURATION = 4.0
    let sound:String?
    
    let scriptToDoInBlack:[CompletableAction]?
    
    init(fadingIn:Bool = true, texts:[String], sound:String? = nil, scriptToDoInBlack:[CompletableAction]? = nil) {
        self.texts           = texts
        self.fadingIn        = fadingIn
        self.sound           = sound
        self.scriptToDoInBlack = scriptToDoInBlack
        
        black.setSize(Game.shared.room.camera.getViewportRect().size)
        black.setPosition(Game.shared.room.camera.getViewportRect().size * -0.5 + Game.shared.room.camera.getScreenCenterPosition())
        
        black.color          = .black
        black.zIndex         = Constants.custScene_zIndex
        black.modulate.alpha = fadingIn ? 0 : 1
        
        label.labelSettings  = Label.settings(size: isPhone ? 110 : 90, font:Constants.secondaryFont)
        label.setPosition(black.getSize() * 0.5)
        label.horizontalAlignment = .center
        label.growVertical = .both
        label.growHorizontal = .both
    }
    
    func run(then: @escaping () -> Void) {
        Game.shared.scene.addChild(node: black)
        if fadingIn {
            /*Game.shared.scene.children.filter { $0 is SKAudioNode }.forEach {
                $0.run(.changeVolume(to: 0, duration: 1))
            }*/
            black.run(.fadeIn(withDuration: 0.3))
        }
        black.addChild(node: label)
        showTexts { [unowned self] in
            if let script = scriptToDoInBlack {
                Script(script) {
                    self.finish(then: then)
                }
                return
            }
            self.finish(then: then)
        }
    }
    
    func showTexts(then: @escaping () -> Void) {
        nextText { [unowned self] finished in
            guard !finished else {
                return then()
            }
            self.showTexts(then:then)
        }
    }
    
    func finish(then: @escaping () -> Void) {
        
        label.run(.fadeOut(withDuration: FADE_DURATION)) { [unowned self] in
            black.run(.fadeOut(withDuration:  1)) { [unowned self] in
                black.removeFromParent()
                /*Game.shared.scene.children.filter { $0 is SKAudioNode }.forEach { $0.run(.changeVolume(to: 0.2, duration: 1))
                }*/
                Game.shared.room.resumeMusicAndAmbience()
                then()
            }
        }
    }
    
    func nextText(then:@escaping(_ finished:Bool) -> Void) {
        guard !texts.isEmpty else {
            return then(true)
        }
        Sound.play(once: sound)
        label.run(.fadeOut(withDuration: FADE_DURATION)) { [unowned self] in
            label.text = __(self.texts.removeFirst())
            //label.setScale(1)
            label.run(.group([
                .fadeIn(withDuration: FADE_DURATION),
                .group([
                    .scale(to: 0.9, duration: TEXT_DURATION),
                    .wait(forDuration: TEXT_DURATION)
                ]),
            ])) {
                then(false)
            }
        }
        
    }
    
}
