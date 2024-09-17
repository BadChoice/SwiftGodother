import Foundation
import SwiftGodot

protocol ChangesRoom : Object {

    var nextRoom:Room.Type { get }
    var hotspot: Vector2   { get }
    var nextRoomEntryPoint: Vector2 { get }
    var nextRoomArrowDirection:ArrowDirection { get }
    var changeRoomSound:String? { get }
    
    
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void)
}

extension ChangesRoom {
    
    var nextRoom:Room.Type {
        NSClassFromString(safeClassName(details.door!.nextRoom)) as! Room.Type
    }
    
    var nextRoomEntryPoint:Vector2 {
        SketchApp.shared.point(Vector2(stringLiteral: details.door!.nextRoomEntryPoint))
    }
    
    var nextRoomFacing:Facing {
        details.door?.nextRoomFacing ?? .right
    }
    
    var nextRoomArrowDirection:ArrowDirection {
        details.door?.nextRoomArrowDirection ?? .up
    }
    
    var facing:Facing {
        details.facing
    }
    
    var changeRoomSound : String? {
        details.door?.changeRoomSound
    }
    
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        then(true)
    }
    
    func goThrough(){
        Game.shared.actor.stopWalk(/*finalPosition: nil*/)
        
        (self as! Object).scripts.shouldChangeToRoom { [unowned self] shouldChange in
            guard shouldChange else {
                return
            }
            
            if Features.doubleDoorClickChangesRoom && Game.shared.goingToDoor == self {
                Game.shared.actor.stopWalk(/*finalPosition: Game.shared.room.actor.node.position*/)
                return changeRoom()
                
            }
            
            Game.shared.goingToDoor = self
            Walk(to: self).run { [unowned self] in
                changeRoom()
            }
        }
    }
    
    private func changeRoom(){
        Sound.play(once: changeRoomSound)
        Game.shared.enter(
            room: nextRoom,
            actorPosition: nextRoomEntryPoint,
            facing: nextRoomFacing
        )
    }
}
