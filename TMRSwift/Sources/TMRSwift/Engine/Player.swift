import SwiftGodot
import Foundation

@Godot
class Player : AnimatedSprite2D, Talks {
    
    //MARK: - TALK
    var talkColor: SwiftGodot.Color { .yellow }
    var talkPosition: SwiftGodot.Vector2 { Vector2(x: 0, y: 0) }
    var voiceType: VoiceType { .male }
    
    //MARK: -
    var frames:SpriteFrames!
    var facing:Facing = .frontRight
    
    var walk:PlayerWalk?
    lazy var footsteps:AudioStreamPlayer = {
        let player = AudioStreamPlayer()
        addChild(node: player)
        return player
    }()
    
    public func face(_ facing:Facing){
        self.facing = facing
        play(name: "\(facing)")
    }
    
    override func _ready() {
        loadAnimations()
        face(.frontRight)
        offset.y = -frames.getFrameTexture(anim: "\(Facing.right)", idx: 0)!.getSize().y / 2 + 20
    }
    
    private func loadAnimations(){
        frames = SpriteFrames()
        
        Facing.allCases.forEach {
            var animation = StringName($0.rawValue)
            frames.addAnimation(anim: animation)
            (0...31).forEach {
                let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
                frames.addFrame(anim: animation, texture:  GD.load(path: "res://assets/actors/crypto/walk/\(animation)/\(number).png") as? Texture2D, duration:0.12)
            }
        }
        
        spriteFrames = frames
    }
    
    override func _process(delta: Double) {
        walk?.update(delta: Float(delta))
    }

    //--------------------------------------
    //MARK: Walk
    //--------------------------------------
    public func walk(path: [Vector2], walkbox:Walkbox, then:(()->Void)? = nil){
        walk = PlayerWalk(path: path, player: self, walkbox:walkbox)
        walk?.walk { then?() }
    }
    
    public func stopWalk(){
        walk = nil
        stop()
        footsteps.stop()
    }
    
    //---------------------------------------
    //MARK: SFX:
    //---------------------------------------
    public func playFootsteps(){
        if let stream:AudioStreamMP3 = GD.load(path: "res://assets/sfx/footsteps.mp3") {
            stream.loop = true
            footsteps.stream = stream
            footsteps.play()
        }
    }
    
}
