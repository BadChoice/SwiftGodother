import SwiftGodot

class Crypto : Player {
 
    var tp:TexturePacker!
    
    override init() {
        super.init()
        tp = TexturePacker(path: "res://assets/actors/crypto/crypto.atlasc", filename:"Crypto.plist")
        tp.load()
        loadAnimations()
    }
    
    func loadAnimations(){
        frames = SpriteFrames()
        
        frames.addAnimation(anim: "walk")
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/01"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/02"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/03"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/04"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/05"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/06"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/07"), duration: 0.55)
        frames.addFrame(anim: "walk", texture: tp.textureNamed(name: "walk/08"), duration: 0.55)
        
        frames.addAnimation(anim: "idle")
        frames.addFrame(anim: "idle", texture: tp.textureNamed(name: "idle/00"), duration: 2.50)
        frames.addFrame(anim: "idle", texture: tp.textureNamed(name: "idle/01"), duration: 2.50)
        
        node.spriteFrames = frames
        
        node.play(name: "walk")
    }
    
    override func face(_ facing: Facing) {
        node.play(name: "walk")
    }
    
    override func stopWalk() {
        super.stopWalk()
        node.play(name: "idle")
    }
}
