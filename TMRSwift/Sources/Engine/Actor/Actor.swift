import SwiftGodot
import Foundation

class Actor : NSObject, Talks, Animable {
    
    //CONSTANTS
    var FOOT_OFFSET:Float { Float(20 * Game.shared.scale) }
    
    //MARK: - TALK
    var talkColor: SwiftGodot.Color { .yellow }
    var talkPosition: SwiftGodot.Vector2 {
        node.position + Vector2(x:0, y: node.offset.y * 2 * node.scale.y) - Vector2(x:0, y:50 * Float(Game.shared.scale))
    }
    var voiceType: VoiceType { .male }
    
    
    lazy var tp2:TexturePacker = {
        Cache.shared.cache(key: "TPCryptoNew") {
            let tp = TexturePacker(path: "res://assets/actors/cryptoNew.atlasc", filename:"cryptoNew.plist")
            tp.load()
            return tp
        }
    }()
    
    //MARK: -
    var node = AnimatedSprite2D()
    var frames:SpriteFrames!
    var facing:Facing = .frontRight
    
    var armLeft  = AnimatedSprite2D()
    var armRight = AnimatedSprite2D()
    
    //MARK: - WALK
    var walk:ActorWalk?
    lazy var footsteps:AudioStreamPlayer = {
        let audioPlayer = AudioStreamPlayer()
        node.addChild(node: audioPlayer)
        return audioPlayer
    }()
    
    public func face(_ facing:Facing){
        self.facing = facing
        if walk?.walkingTo != nil {
            GD.print("[ANIMATION] WALK \(facing)")
            node.play(name: "walk-\(facing)")
        } else {
            animateIdle()
        }
    }
        
    public func setAwayScale(_ scale:Float){
        node.scale = Vector2(x: scale, y:scale)
    }
    
    override init() {
        super.init()
        loadAnimations()
        face(.frontRight)
        setupFootOffset()
    }
    
    func loadAnimations(){
        frames = SpriteFrames()
        
        Facing.allCases.forEach { facing in
            var animation = StringName("walk-" + facing.rawValue)
            frames.addAnimation(anim: animation)
            (0...15).forEach {
                let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
                frames.addFrame(
                    anim: animation,
                    texture:  tp2.textureNamed("walk/\(facing.rawValue)/\(number)"),
                    duration:0.24
                )
            }
        }
        
        Facing.allCases.forEach { facing in
            if facing == .right || facing == .left { return }
            var animation = StringName("idle-" + facing.rawValue)
            frames.addAnimation(anim: animation)
            (0...19).forEach {
                let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
                frames.addFrame(
                    anim: animation,
                    texture:  tp2.textureNamed("idle/\(facing.rawValue)/\(number)"),
                    duration:0.24
                )
            }
        }
        
        
        //Pickup front
        frames.addAnimation(anim: "pickup-front")
        (0...34).forEach {
            let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
            frames.addFrame(
                anim: "pickup-front",
                texture:  tp2.textureNamed("pickup/front/\(number)"),
                duration:0.12
            )
            frames.setAnimationLoop(anim: "pickup-front", loop: false)
        }
                    
        node.spriteFrames = frames
        
        loadExpressions()
    }
    
    private func loadExpressions(){
        armRight.spriteFrames = SpriteFrames()
        armRight.spriteFrames!.addAnimation(anim: "shy")
        (0...35).forEach {
            let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
            armRight.spriteFrames!.addFrame(
                anim: "shy",
                texture:  tp2.textureNamed("expressions/shy/front/\(number)"),
                duration:0.24)
        }
        
        armRight.play(name: "shy")
        armRight.zIndex = -1
        armRight.offset.y = -armRight.spriteFrames!.getFrameTexture(anim: "shy", idx: 0)!.getSize().y / 2 + FOOT_OFFSET
        node.addChild(node: armRight)
    }
    
    func setupFootOffset(){
        node.offset.y = -frames.getFrameTexture(anim: "walk-\(Facing.right)", idx: 0)!.getSize().y / 2 + FOOT_OFFSET
    }
    
    func _process(delta: Double) {
        walk?.update(delta: Float(delta))
    }

    //--------------------------------------
    //MARK: Animations
    //--------------------------------------
    func animate(_ animation: String?) {
        GD.print("[ANIMATION] \(animation)")
        
        if animation == "pickup" {
            node.play(name: "pickup-front")
        }
        
        node.animationFinished.connect { [self] in
            GD.print("[ANIMATION] FINISHED")
            animateIdle()
            node.animationFinished.connect { }
        }
    }
    
    func animateIdle(){
        GD.print("[ANIMATION] IDLE")
        if facing == .right {
            facing = .frontRight
        }
        if facing == .left {
            facing = .frontLeft
        }
        node.play(name: "idle-\(facing)")
    }
    
    //--------------------------------------
    //MARK: Expressions
    //--------------------------------------
    func setExpression(_ expression:Expression?) {
        setExpression(eyes: expression)
        setExpression(mouth: expression)
    }
    
    func setExpression(eyes: Expression?) {
    
    }
    
    func setExpression(mouth: Expression?) {

    }
    
    func setArmsExpression(_ expression:ArmsExpression?) {
        
    }
    
    //--------------------------------------
    //MARK: Walk
    //--------------------------------------
    public func walk(path: [Vector2], walkbox:Walkbox, then:(()->Void)? = nil){
        if walk?.checkIfFastWalk(newDestination: path.last) ?? false {
            return
        }
        
        walk = ActorWalk(path: path, actor: self, walkbox:walkbox)
        walk?.walk { then?() }
    }
    
    public func stopWalk(){
        walk = nil
        node.stop()
        footsteps.stop()
        GD.print("[ANIMATION] STOP WALK")
        animateIdle()
    }
    
    //---------------------------------------
    //MARK: SFX:
    //---------------------------------------
    public func playFootsteps(){
        footsteps.removeFromParent()
        if let stream:AudioStreamOggVorbis = GD.load(path: "res://assets/" + (Game.shared.room.details.footsteps ?? .concrete).filename()) {
            node.addChild(node: footsteps)
            stream.loop = true
            footsteps.stream = stream
            footsteps.play()
        }

    }
    
}
