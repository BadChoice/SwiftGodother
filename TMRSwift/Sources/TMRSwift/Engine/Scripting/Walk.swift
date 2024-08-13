import SwiftGodot
import Foundation

struct Walk : CompletableAction {
    
    let actor:Actor?
    let room:Room
    let point:Vector2?
    let facing:Facing?
    
    init(to point:Vector2?, facing:Facing? = nil){
        self.actor  = Game.shared.room.actor
        self.room   = Game.shared.room
        self.point  = point
        self.facing = facing
    }
    
    init(to object:Object, facing:Facing? = nil){
        self.actor = Game.shared.room.actor
        self.room   = Game.shared.room
        self.point  = object.hotspot
        self.facing = facing ?? object.facing
    }
    
    /*init(to point:Point, facing:Direction? = nil){
        self.actor = Game.shared.room.actor
        self.room   = Game.shared.room
        self.point  = point.fromSketch
        self.facing = facing
    }*/
    
    func run(then:@escaping ()->Void) {
        guard let point = point else {
            return then()
        }
        guard let walkBox = room.walkbox else {
            return then()
        }
        if var path = walkBox.calculatePath(from:(actor ?? room.actor).node.position, to:point){
            if Constants.debug {
                let pathNode = Line2D()
                pathNode.closed = false
                Walkbox.drawPoints(node: pathNode, points: path, color: .yellow, width: 2)
                room.addChild(node: pathNode)
            }
            //room.actor.walk(path: path, walkbox: room.walkbox) {
            (actor ?? room.actor).walk(path: path, walkbox: room.walkbox){
                if let facing = self.facing  {
                    (actor ?? room.actor).face(facing)
                }
                then()
            }
        }
    }
}
