import Foundation

protocol ChangesRoom : Object {

    /*var nextRoom:Room.Type { get }
    var hostspot: Point?   { get }
    var nextRoomEntryPoint: Point { get }
    var nextRoomArrowDirection:ArrowDirection { get }
    var changeRoomSound:String? { get }
     */
    
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void)
}

extension ChangesRoom {
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        then(true)
    }
}
