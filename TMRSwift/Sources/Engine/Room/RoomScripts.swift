
class RoomScripts {
    weak var scriptedRoom:Room!
    
    required init(room:Room) {
        scriptedRoom = room
    }
    
    var actorType:Actor.Type { Crypto.self }
    func onEnter(){ }
    func onExit(){ }
}
