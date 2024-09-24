import Foundation
import SwiftGodot

extension PirateScripts : NpcScripts {
    
    var prefix: String { "pirate/pirate" }
    
    func createNode() {
        npc.node = Sprite2D(texture: texture("pirate/pirate")!)
        npc.face = Sprite2D(texture: texture("pirate/face")!)
        npc.node?.addChild(node: npc.face)
        npc.face.position = Point(x: 120, y: -10) * Game.shared.scale
        npc.subsprites["eyes"] = Sprite2D(texture: texture(prefix + "-eyes-blink")!)
        npc.face?.addChild(node: npc.eyes)
        npc.eyes.position = Point(x: -36, y: -19) * Game.shared.scale
        npc.eyes.zIndex = 1
    }
    
    func animateNpc(_ animation: String?) {
        npc.node?.removeAllActions()
        npc.face.removeAllActions()
        npc.subsprites.forEach { _, sprite in sprite.removeAllActions() }
        
        if animation == nil {
            npc.node?.set(texture:"pirate/pirate")
            npc.face.set(texture:"pirate/face")
            blink()
        }
        
        if animation == "talk" {
            blink()
            talk()
        }
    }
    
    private func talk(){
        npc.face.repeatForever(sequence:[
            .wait(forDuration: 0.6),
            .rotate(toAngle: 0.08, duration: 0),
            .wait(forDuration: 0.6),
            .rotate(toAngle: 0, duration: 0)
        ])
        
        npc.face.animateForever(textures([
            "pirate/face-talk-1",
            "pirate/face-talk-2",
            "pirate/face",
        ]), timePerFrame: 0.2)
    }
    
    private func blink(){
        npc.eyes.show(withTexture: texture(prefix + "-eyes-blink"))
        npc.eyes.repeatForever(sequence:[
            .fadeOut(withDuration: 0),
            .wait(forDuration: 2.2),
            .fadeIn(withDuration: 0),
            .wait(forDuration: 0.4),
        ])
    }
}
