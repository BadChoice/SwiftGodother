import Foundation
import SwiftGodot

extension MaxKidScripts : NpcScripts {
    
    var prefix: String { "max/max" }
    
    func createNode() {
        let npc = scriptedObject as! NonPlayableCharacter
        
        npc.node  = Sprite2D(texture: texture(prefix + "-body")!)
        //node?.anchorPoint = CGPoint(x:0, y:1)
        
        npc.face = Sprite2D(texture: texture(prefix + "-head")!)
        npc.node?.addChild(node: npc.face)
        npc.face.zIndex = 5
        npc.face.position = Point(x: 115, y: -50) * Game.shared.scale
        
        animate(nil)
    }
    
}
