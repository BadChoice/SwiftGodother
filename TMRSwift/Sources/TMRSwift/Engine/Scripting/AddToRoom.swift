import Foundation

struct AddToRoom : CompletableAction {
    
    let object:Object
    let sound:String?
    
    init(_ object:Object, sound:String? = nil){
        self.object = object
        self.sound = sound
    }
    
    func run(then: @escaping () -> Void) {
        let roomObject = Game.shared.room.objects.first {
            $0.name == object.name
        }
        if let sound = sound {
            Sound.play(once:sound)
        }
        roomObject?.addToRoom(Game.shared.room)
        then()
    }
}
