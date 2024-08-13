import Foundation

struct GoThroughDoor : CompletableAction {
    let door:ChangesRoom
    
    init(_ door:ChangesRoom){
        self.door = door
    }
    
    func run(then: @escaping () -> Void) {
        Script([
            Walk(to: door),
            //ChangeRoom(door.nextRoom, at: door.nextRoomEntryPoint.fromSketch),
        ], then:then)
    }
}
