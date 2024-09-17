import Foundation
import SwiftGodot

extension BarmanScripts : NpcScripts {
    
    var prefix: String { "barman/" }
    
    var npc:NonPlayableCharacter {
        scriptedObject as! NonPlayableCharacter
    }
    
    func createNode() {
                
        npc.node   = Sprite2D(texture: texture(prefix + "barman")!)
        npc.face   = Sprite2D(texture: texture(prefix + "face")!)
        npc.node?.addChild(node: npc.face)
        npc.face.position = Point(x: 60, y: -46) * Game.shared.scale

        npc.subsprites["eyes"] = Sprite2D(texture: texture(prefix + "barman-eyes-blink")!)
        npc.face?.addChild(node: npc.eyes)
        npc.eyes.position = Point(x: -6, y: 14) * Game.shared.scale
        npc.eyes.hide()
        
        animate(nil)
    }
    
    func animateNpc(_ animation: String?) {
        npc.node?.removeAllActions()
        npc.face.removeAllActions()
        npc.face.rotation = 0
        npc.subsprites.forEach { _, sprite in sprite.removeAllActions() }
        
        if animation == nil {
            npc.node?.set(texture:"barman/barman")
            npc.face?.set(texture:"barman/face")
            blink()
        }
        
        if animation == "talk" {
            return talkAnimation()
        }
    }
    
    func blink(){
        npc.eyes.repeatForever(sequence:[
            .setTexture(texture("barman/barman-eyes-blink")),
            .fadeOut(withDuration: 0),
            .wait(forDuration: 3),
            .fadeIn(withDuration: 0),
            .wait(forDuration: 0.2),
        ])
    }
    
    func talkAnimation(){
        
        npc.face.repeatForever(sequence:[
            .wait(forDuration: 0.6),
            .rotate(toAngle: 0.08, duration: 0),
            .wait(forDuration: 0.6),
            .rotate(toAngle: 0, duration: 0)
        ])
        
        npc.face.animateForever([
            "barman/talk-2",
            "barman/talk-1",
            "barman/talk-2",
            "barman/talk-3",
            "barman/face",
        ], timePerFrame: 0.2)
    }
}
