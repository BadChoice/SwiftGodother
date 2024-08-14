import SwiftGodot

class Crypto : Actor {
     
    lazy var tp:TexturePacker = {
        Cache.shared.cache(key: "TPCrypto") {
            let tp = TexturePacker(path: "res://assets/actors/crypto/crypto.atlasc", filename:"crypto.plist")
            tp.load()
            return tp
        }
    }()
    
    var face = Sprite2D()
    
    override init() {
        super.init()
        loadAnimations()
    }
    
    func loadAnimations(){
        frames = SpriteFrames()
        
        frames.createAnimation(name: "walk",    prefix: "walk/",    frames: 1...8, atlas:tp, timePerFrame:0.5, looped:true)
        frames.createAnimation(name: "combine", prefix: "combine/", frames: 0...17, atlas: tp, timePerFrame: 0.5, looped: false)
    
        frames.createAnimation(name: "idle", prefix: "idle/", frames: 0...1, atlas: tp, timePerFrame: 2.50, looped: true)
        
        frames.addAnimation(anim: "no_face_profile")
        frames.addFrame(anim: "no_face_profile", texture: tp.textureNamed(name: "no-face"))
        frames.setAnimationLoop(anim: "no_face_profile", loop: false)
        
        frames.addAnimation(anim: "pickup")
        frames.addFrame(anim: "pickup", texture: tp.textureNamed(name: "pickup/normal"))
        frames.setAnimationLoop(anim: "pickup", loop: false)
        
        frames.addAnimation(anim: "pickup-up")
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed(name: "pickup/normal"), duration: 0.4)
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed(name: "pickup/up"), duration: 0.4)
        frames.setAnimationLoop(anim: "pickup-up", loop: false)
        
        frames.addAnimation(anim: "pickup-low")
        frames.addFrame(anim: "pickup-low", texture: tp.textureNamed(name: "pickup/low"))
        frames.setAnimationLoop(anim: "pickup-low", loop: false)
        
        frames.addAnimation(anim: "pickup-really-up")
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/normal"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/up"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/really-up"), duration: 0.5)
        frames.setAnimationLoop(anim: "pickup-really-up", loop: false)
                
        
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
                        
        face.texture = tp.textureNamed(name: "talk/face")
        face.position = Vector2(x:-6, y:-236) * Game.shared.scale
        node.addChild(node: face)
        face.hide()
        
        node.spriteFrames = frames
        
        node.offset.y = -frames.getFrameTexture(anim: "walk", idx: 0)!.getSize().y / 2 + (20 * Float(Game.shared.scale))
        node.play(name: "walk")
    }
    

    //---------------------------------------------------
    //MARK: - Animations
    //---------------------------------------------------
    override func animate(_ animation: String?) {
        clearAnimations()
        
        if animation?.contains("pickup") ?? false {
            return animatePickup(animation!)
        }
        
        switch animation {
        case "talk"                      : animateTalk()
        case Self.combine.name           : animateCombine()
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
        node.play(name: StringName(animation))
    }
    
    private func animateCombine(){
        if [.front, .back].contains(facing) { face(.right) }
        //face.hide()
        node.play(name: "combine")
    }
    
    //---------------------------------------------------
    //MARK: - Facing
    //---------------------------------------------------
    override func face(_ facing: Facing) {
        self.facing = facing
        
                
        if walk?.walkingTo != nil {
            node.play(name: "walk")
        } else {
            node.play(name: "idle")
        }
        
        if facing == .left && node.scale.x < 0 { return }
        if facing == .right && node.scale.x > 0 { return }
        
        node.scale.x *= -1
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
        
    //---------------------------------------------------
    //MARK: - Animations
    //---------------------------------------------------
    static var combine:  Animation {
        .init(name: "combine", durationMs: 18 * 100, sound:"combine_items")
    }
}
