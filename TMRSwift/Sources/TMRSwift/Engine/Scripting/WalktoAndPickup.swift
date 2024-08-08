import Foundation

struct WalkToAndPickup : CompletableAction {
    
    let object:Inventoriable
    let facing:Facing?
    let animation:String
    let sound:String?
    
    init(_ object:Inventoriable, facing:Facing? = nil, reach:Reach? = nil, animation:String? = nil, sound:String? = "pop" ){
        self.object = object
        self.facing = facing ?? object.facing
        self.animation = animation ?? reach?.animation ?? object.details.reach?.animation ?? "pickup"
        self.sound = sound
    }
    
    func run(then: @escaping () -> Void) {
        Script([
            Walk(to: object),
            Animate(animation, facing:facing, sound: sound),
            Pickup(object),
        ], isSubscript:true, then:then)
    }
    
}
