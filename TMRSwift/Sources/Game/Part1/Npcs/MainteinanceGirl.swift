import SwiftGodot

extension MainteinanceGirlScripts : NpcScripts {
    
    var matchesSound:Node? { npc.sounds["matches"] }
    
    var prefix: String { "leia/leia" }
    
    func createNode() {
        npc.node = Sprite2D(texture: texture("leia/leia")!)
        npc.face = Sprite2D(texture: texture("leia/face")!)
        npc.node?.addChild(node: npc.face)
        npc.face.position = Point(x: 180, y: 25)  * Game.shared.scale
    }
    
    func animateNpc(_ animation: String?) {
        npc.node?.removeAllActions()
        npc.face.removeAllActions()
        matchesSound?.removeFromParent()
        
        if animation == nil {
            if MainteinanceGirl.hasMatches {
                animateMatches()
            } else {
                animateLighter()
            }
            blink()
        }
        
        if animation == "matches" {
            animateMatches()
        }
        
        if animation == "talk" {
            talk()
        }
    }
    
    private func talk(){
        npc.face.animateForever([
            "leia/face-talk-01",
            "leia/face-talk-02",
            "leia/face-blink",
            "leia/face-talk-03",
        ], timePerFrame: 0.2)
    }
        
    private func animateLighter(){
        npc.node?.run(.repeatForever(sequence:[
            .wait(forDuration: 2),
            .animate(textures([
                "leia/spark01",
                "leia/spark02",
                "leia/spark03",
                "leia/spark04",
                "leia/spark05",
                "leia/leia",
            ]), timePerFrame: 0.1)
        ]))
    }
    
    private func animateMatches(){
        npc.sounds["matches"] = Sound.looped("maintenance_matches_loop")
        npc.node?.addChild(node: matchesSound!)
        
        npc.node?.animateForever([
            "leia/matches",
            "leia/matches-on",
        ], timePerFrame: 0.2)
    }
    
    private func blink(){
        npc.face?.run(.repeatForever(sequence: [
            .setTexture(texture("leia/face")),
            .wait(forDuration: 4),
            .setTexture(texture("leia/face-blink")),
            .wait(forDuration: 0.2)
        ]))
    }
}
