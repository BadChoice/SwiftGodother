import Foundation
import SwiftGodot

extension RevisorScripts : NpcScripts {
    
    var prefix: String { "revisor/revisor" }

    func createNode() {
        
        let npc = scriptedObject as! NonPlayableCharacter
        
        npc.node  = Sprite2D(texture: texture(prefix)!)
        //node?.anchorPoint = CGPoint(x:0, y:1)
        
        npc.face = Sprite2D(texture: texture(prefix + "-face")!)
        npc.node?.addChild(node: npc.face)
        npc.face.position = Point(x: 285, y: 70)  * Game.shared.scale
        
        npc.subsprites["eyes"] = Sprite2D(texture: texture("revisor/revisor-eyes-blink")!)
        npc.face.addChild(node: npc.eyes)
        npc.eyes.position = Point(x: 23, y: 7)  * Game.shared.scale
        npc.eyes.zIndex = 1
                
        //animateBlink()
    }
}
