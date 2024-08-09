import SwiftGodot

class Crypto : Actor {
 
    var tp:TexturePacker!
    
    var face = Sprite2D()
    
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
        
        frames.addAnimation(anim: "pickup")
        frames.addFrame(anim: "pickup", texture: tp.textureNamed(name: "pickup/normal"))
                
        
        //pickup/normal
        //pickup/up
        //pickup/really-up
        //pickup/pickup-back-low.png
        //pickup/pickup-back-up.png
        //pickup/low
        //pickup/pickup-back
        
        //puzzles/hand-lightgun-dark.png
        
        //no-right-hand.png
        //no-face
        //front-no-face
        //back-no-face
        
        //puzzles/hand-spiral-01 - 03
        
        
        //talk/face-front
        //talk/face
        //talk/face-jaw-open
        //talk/face-back-talk
        //talk/face-back
        //talk/face-look-phone.png
                
        //combine/00.png -- 12
        
        face.texture = tp.textureNamed(name: "talk/face")
        face.position = Vector2(x:-6, y:-236) * Game.shared.scale
        node.addChild(node: face)
        face.hide()
                
                
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
    }
    

    //MARK: - Animations
    override func animate(_ animation: String?) {
        clearAnimations()
        
        if animation?.contains("pickup") ?? false {
            return animatePickup(animation!)
        }
        
        switch animation {
        case "talk" : animateTalk()
        default: node.play(name: "idle")
        }
    }
    
    private func clearAnimations() {
        face.hide()
    }

    private func animateTalk(){
        node.play(name: "no_face_profile")
        node.pause()
        face.show()
    }
    
    private func animatePickup(_ animation:String){
        node.play(name: "pickup")
        node.pause()
    }
    
    //MARK: - Facing
    override func face(_ facing: Facing) {
        self.facing = facing
                
        if walk?.walkingTo != nil {
            node.play(name: "walk")
        } else {
            node.play(name: "idle")
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
