import Foundation
import SwiftGodot

extension MaxKidScripts : NpcScripts {
    
    var prefix: String { "max/max" }
    
    func createNode() {
        let npc = scriptedObject as! NonPlayableCharacter
        
        npc.node = Sprite2D(texture: texture(prefix + "-body")!)
        npc.face = Sprite2D(texture: texture(prefix + "-head")!)
        npc.node?.addChild(node: npc.face)
        npc.face.zIndex = 5
        npc.face.position = Point(x: 115, y: -50) * Game.shared.scale
    }
    
    
    func animateNpc(_ animation: String?) {
        let npc = scriptedObject as! NonPlayableCharacter
        
        npc.node?.removeAllActions()
        npc.face.removeAllActions()
        
        if animation == "talk" {
            npc.face.run(.repeatForever(sequence: [
                .wait(forDuration: 0.6),
                .rotate(toAngle: -0.08, duration: 0),
                .wait(forDuration: 0.6),
                .rotate(toAngle: 0, duration: 0)
            ]))
        }
    }
}
