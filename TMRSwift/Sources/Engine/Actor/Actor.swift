import SwiftGodot
import Foundation

class Actor : NSObject, Talks, Animable {
    
    //MARK: - TALK
    var talkColor: SwiftGodot.Color { .yellow }
    var talkPosition: SwiftGodot.Vector2 {
        node.position + Vector2(x:0, y: node.offset.y * 2 * node.scale.y) - Vector2(x:0, y:50 * Float(Game.shared.scale))
    }
    var voiceType: VoiceType { .male }
    
    //MARK: -
    var node = AnimatedSprite2D()
    var frames:SpriteFrames!
    var facing:Facing = .frontRight
    
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
        node.offset.y = -frames.getFrameTexture(anim: "walk-\(Facing.right)", idx: 0)!.getSize().y / 2 + (20 * Float(Game.shared.scale))
    }
    
    private func loadAnimations(){
        frames = SpriteFrames()
        
        Facing.allCases.forEach { facing in
            var animation = StringName("walk-" + facing.rawValue)
            frames.addAnimation(anim: animation)
            (0...15).forEach {
                let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
                frames.addFrame(anim: animation, texture:  GD.load(path: "res://assets/actors/crypto_new/walk/\(facing.rawValue)/\(number).png") as? Texture2D, duration:0.24)
            }
        }
        
        Facing.allCases.forEach { facing in
            if facing == .right || facing == .left { return }
            var animation = StringName("idle-" + facing.rawValue)
            frames.addAnimation(anim: animation)
            (0...19).forEach {
                let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
                frames.addFrame(anim: animation, texture:  GD.load(path: "res://assets/actors/crypto_new/idle/\(facing.rawValue)/\(number).png") as? Texture2D, duration:0.24)
            }
        }
        
        
        //Pickup front
        frames.addAnimation(anim: "pickup-front")
        (0...34).forEach {
            let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
            frames.addFrame(anim: "pickup-front", texture:  GD.load(path: "res://assets/actors/crypto_new/pickup/front/\(number).png") as? Texture2D, duration:0.12)
            frames.setAnimationLoop(anim: "pickup-front", loop: false)
        }
        
        
        node.spriteFrames = frames
    }
    
    func _process(delta: Double) {
        walk?.update(delta: Float(delta))
    }

    //--------------------------------------
    //MARK: Animations
    //--------------------------------------
    func animate(_ animation: String?) {
        if animation == "pickup" {
            node.play(name: "pickup-front")
        }
        
        node.animationFinished.connect { [self] in
            animateIdle()
            node.animationFinished.connect { }
        }
    }
    
    func animateIdle(){
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
