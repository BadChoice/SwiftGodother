import Foundation

class Face : CompletableAction {
    
    let animable:Animable?
    let facing:Facing
    
    init(actor: Animable? = nil, _ facing: Facing) {
        animable = actor
        self.facing = facing
    }
        
    func run(then: @escaping () -> Void) {
        (animable ?? Game.shared.actor).face(facing)
        then()
    }
}
