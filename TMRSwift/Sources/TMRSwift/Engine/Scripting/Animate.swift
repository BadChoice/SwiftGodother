import Foundation

struct Animate : CompletableAction {
    
    let actor:Animable
    let ms:Int
    let animation:String?
    let facing:Facing?
    let sound:String?
    
    /**
    * Use ms = 0 to leave the animation playing
     */
    init(actor:Animable? = nil, _ animation:String?, ms:Int = 400, facing:Facing? = nil, sound:String? = nil) {
        self.actor      = actor ?? Game.shared.room.actor
        self.animation  = animation
        self.ms         = ms
        self.facing     = facing
        self.sound      = sound
    }
    
    init(actor:Animable? = nil, _ animation:Animation, facing:Facing? = nil, ms:Int? = nil) {
        self.init(actor:actor, animation.name, ms:ms ?? animation.durationMs, facing: facing, sound:animation.sound)
    }
    
    init(actor:Animable? = nil, reach:Reach = .normal, facing:Facing? = nil, ms:Int = 400, sound:String? = nil) {
        self.init(actor:actor, reach.animation, ms:ms, facing: facing, sound:sound)
    }
    
    func run(then: @escaping () -> Void) {
        if let facing = facing {
            actor.face(facing)
        }
        
        if let sound = sound {
            Sound.play(once:sound)
        }
        
        actor.animate(animation)
        
        if ms == 0 {
            return then()
        }
        
        Delay(ms: ms).run {
            actor.animate(nil)
            then()
        }
    }
}

struct Animation {
    var name:String
    var durationMs:Int
    var sound:String?
}
