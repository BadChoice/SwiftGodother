import SwiftGodot

class Crypto : Actor {
 
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
        
        frames.addAnimation(anim: "no_face_profile")
        frames.addFrame(anim: "no_face_profile", texture: tp.textureNamed(name: "no-face"))
                
        
        //pickup/normal
        //pickup/up
        //pickup/really-up
        //pickup/pickup-back-low.png
        //puzzles/hand-lightgun-dark.png
        //talk/face-look-phone.png
        //no-right-hand.png
        //no-face
        
        //combine/00.png --
                
        frames.getAnimationNames().forEach {
            for i in 0...frames.getFrameCount(anim: StringName($0)) {
                if let frameTexture = frames.getFrameTexture(anim: StringName($0), idx: i) {
                    //GD.print($0, frameTexture.getSize(), frameTexture.getRegion())
                }
            }
        }
        
        node.spriteFrames = frames
        
        node.offset.y = -frames.getFrameTexture(anim: "walk", idx: 0)!.getSize().y / 2 + (20 * Float(Game.shared.scale))
        node.play(name: "walk")
        
        
        let idle1 = Sprite2D(texture: tp.textureNamed(name: "idle/00")!)
        let noFace = Sprite2D(texture: tp.textureNamed(name: "no-face")!)
        
        node.addChild(node:idle1)
        node.addChild(node:noFace)
    }
    
    override func face(_ facing: Facing) {
        self.facing = facing
                
        if walk?.walkingTo != nil {
            node.play(name: "walk")
        } else {
            node.play(name: "idle")
        }
    }
    
    override func animate(_ animation: String?) {
        switch animation {
        case "talk" : node.play(name: "no_face_profile")
        default: node.play(name: "idle")
        }
    }
    
    private func getFacingScale() -> Vector2 {
        switch facing {
        case .left, .backLeft, .frontLeft: Vector2(x: -1, y: 1)
        default: Vector2(x: 1, y: 1)
        }
    }
    
    override func setAwayScale(_ scale: Float) {
        node.scale = Vector2(x: scale, y:scale) * getFacingScale()
    }
    
    override func stopWalk() {
        super.stopWalk()
        node.play(name: "idle")
    }
}
