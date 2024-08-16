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
        
        frames.createSingleFrameAnimation(name:"no_face_profile", textureName: "no-face", atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup",          textureName: "pickup/normal", atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-low",      textureName: "pickup/low", atlas:tp)
        
        frames.addAnimation(anim: "pickup-up")
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed(name: "pickup/normal"), duration: 0.4)
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed(name: "pickup/up"), duration: 0.4)
        frames.setAnimationLoop(anim: "pickup-up", loop: false)
        
        frames.addAnimation(anim: "pickup-really-up")
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/normal"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/up"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed(name: "pickup/really-up"), duration: 0.5)
        frames.setAnimationLoop(anim: "pickup-really-up", loop: false)
                
        
        frames.createSingleFrameAnimation(name:"front",              textureName: "front-no-face",          atlas:tp)
        frames.createSingleFrameAnimation(name:"back",               textureName: "back-no-face",           atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-pickup", textureName: "pickup/pickup-back",     atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-up",     textureName: "pickup/pickup-back-up",  atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-low",    textureName: "pickup/pickup-back-low", atlas:tp)
        
        //puzzles/hand-lightgun-dark.png
        
        //no-right-hand.png
        //no-face
        
        //puzzles/hand-spiral-01 - 03

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
        default: animateIdle()
        }
    }
    
    private func clearAnimations() {
        face.removeAllActions()
        face.hide()
    }

    private func animateIdle(){
        if facing == .back  { return face(.back) }
        if facing == .front { return face(.front) }
        
        node.play(name: "idle")
    }
    
    private func animateTalk(){
        if facing == .back  {
            face.show()
            face.animateForever([
                tp.textureNamed(name: "talk/face-back")!,
                tp.textureNamed(name: "talk/face-back")!,
                tp.textureNamed(name: "talk/face-back-talk")!,
            ], timePerFrame: 0.2)
            return
        }
        if facing == .front {
            face.show()
            face.run(.repeatForever(.sequence([
                .wait(forDuration: 0.8),
                .moveBy(x: 0, y: 1, duration: 0),
                .wait(forDuration: 0.2),
                .moveBy(x: 0, y: -1, duration: 0)
            ])))
            return
        }
        
        node.play(name: "no_face_profile")
        
        face.animateForever([
            tp.textureNamed(name: "talk/face")!,
            tp.textureNamed(name: "talk/face")!,
            tp.textureNamed(name: "talk/face-jaw-open")!
        ], timePerFrame: 0.2)
        
        face.run(.repeatForever(.sequence([
            .rotate(toAngle: 0, duration: 0),
            .wait(forDuration: 0.2),
            .rotate(toAngle: 0.08, duration: 0),
            .wait(forDuration: 0.4)
        ])))
        
        face.show()
    }
    
    private func animatePickup(_ animation:String){
        if facing == .back {
            face.show()
            return node.play(name: StringName("pickup-back-\(animation)"))
        }
        node.play(name: StringName(animation))
    }
    
    private func animateCombine(){
        if [.front, .back].contains(facing) { face(.right) }
        face.hide()
        node.play(name: "combine")
    }
    
    //---------------------------------------------------
    //MARK: - Facing
    //---------------------------------------------------
    override func face(_ facing: Facing) {
        self.facing = facing
                        
        if walk?.walkingTo != nil {
            node.play(name: "walk")
            face.hide()
            return
        } else {
            node.play(name: "idle")
        }
        
        if [.left, .right].contains(facing) {
            face.hide()
            if facing == .left && node.scale.x < 0  { return }
            if facing == .right && node.scale.x > 0 { return }
            
            node.scale.x *= -1
        }
        
        face.show()
        if facing == .front {
            node.play(name: "front")
            face.texture = tp.textureNamed(name: "talk/face-front")
        }
        if facing == .back  {
            node.play(name: "back")
            face.texture = tp.textureNamed(name: "talk/face-back")
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
        
    //---------------------------------------------------
    //MARK: - Animations
    //---------------------------------------------------
    static var combine:  Animation {
        .init(name: "combine", durationMs: 18 * 100, sound:"combine_items")
    }
}
