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
        
        npc.subsprites["eyes"] = Sprite2D(texture: texture(prefix + "-eyes-blink")!)
        npc.face.addChild(node: npc.eyes)
        npc.eyes.position = Point(x: 23, y: -7)  * Game.shared.scale
        npc.eyes.zIndex = 1
    }
    
    func animateNpc(_ animation: String?) {
        npc.node?.removeAllActions()
        
        npc.eyes.hide()
        npc.eyes.removeAllActions()
        npc.face.rotation = 0
        npc.face.removeAllActions()
        npc.face.show(withTexture: texture(prefix + "-face"))
        
        if animation == nil {
            npc.node?.set(texture: prefix)
            return animateBlink()
        }
        
        if animation == "talk" {
            return animateTalk()
        }
        
        if animation == "show-beard" {
            npc.node?.set(texture: "revisor/beard" )
            return
        }
        
        if animation == "count-tickets" {
            return animateCountTickets()
        }
        
        if animation == "stop-count-tickets" {
            return animateStopCountTickets()
        }
    }
    
    private func animateTalk(){
        let frameDuration = 0.3
        npc.face.repeatForever(sequence: [
            .wait(forDuration: 0.9),
            .rotate(byAngle: 0.02, duration: 0),
            .wait(forDuration: 0.2),
            .rotate(byAngle: -0.03, duration: 0),
        ])
        npc.face.animateForever([
            prefix + "-face",
            prefix + "-face-talk",
        ], timePerFrame: frameDuration)
    }
    
    private func animateCountTickets(){
        npc.face.hide()
        npc.node?.run(.animate(textures([
                "revisor/front",
                "revisor/back",
                "revisor/back-pickup",
                "revisor/back-pickup",
                "revisor/back-pickup",
                "revisor/back-pickup",
                "revisor/back",
            ]), timePerFrame: 0.2)
        )
    }
    
    private func animateStopCountTickets(){
        npc.face.run(.sequence([
            .fadeOut(withDuration: 0),
            .wait(forDuration: 0.2 * 5),
            .fadeIn(withDuration: 0),
        ]))
        npc.node?.run(.animate(textures([
                "revisor/back-pickup",
                "revisor/back-pickup",
                "revisor/back-pickup",
                "revisor/back",
                "revisor/front",
                "revisor/revisor",
            ]), timePerFrame: 0.2)
        )
    }
    
    private func animateBlink(){
        npc.eyes.show(withTexture: texture("revisor/revisor-eyes-blink"))
        npc.eyes.run(.repeatForever(.sequence([
            .fadeOut(withDuration: 0),
            .wait(forDuration: 4),
            .fadeIn(withDuration: 0),
            .wait(forDuration: 0.2),
            .fadeOut(withDuration: 0),
            .wait(forDuration: 4),
            .fadeIn(withDuration: 0),
            .wait(forDuration: 0.2),
            .fadeOut(withDuration: 0),
            .wait(forDuration: 0.2),
            .fadeIn(withDuration: 0),
            .wait(forDuration: 0.2),
        ])))
    }
}
