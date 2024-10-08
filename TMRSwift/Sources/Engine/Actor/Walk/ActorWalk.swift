import Foundation
import SwiftGodot

class ActorWalk {
    
    var path:[Vector2]
    let actor:Actor
    var walkingTo:Vector2?
    let walkbox:Walkbox
    var walkingToSpeedFactor = Vector2(x: 1, y: 1)
    var walkCompletion:(()->Void)?
    var fastWalk:Bool = false
    
    init(path:[Vector2], actor:Actor, walkbox:Walkbox){
        self.path = path.reversed()
        self.actor = actor
        self.walkbox = walkbox
    }
    
    public func walk(then:(()->Void)? = nil){
        
        if let to = path.first, actor.node.position.near(to) {
            actor.node.position = to
            then?()
            return
        }
        
        //GD.print(path)
        
        walkCompletion = then
        walkTo(position: self.path.popLast())
        actor.playFootsteps()
    }
    
    private func walkTo(position:Vector2?){
        walkingTo = position
        calculateMediaVelocity(from: actor.node.position, to: position)
    }
    
    public func checkIfFastWalk(newDestination:Vector2?) -> Bool {
        guard let newDestination else { return false }
        
        if newDestination.near(path.first ?? walkingTo ?? .zero) {
            fastWalk = true
            return true
        }
        return false
    }
    
    public func update(delta:Float) {
        guard let walkingTo else { return }
        
        let awayFactor = walkbox.getAwayScaleForActorAt(point: actor.node.position)
        
        let walkSpeed:Float = getWalkSpeed(awayFactor:awayFactor)
        
        let nextPoint = Vector2(
            x: actor.node.position.x.near(walkingTo.x) ? 0 : (((walkingTo.x > actor.node.position.x) ? walkSpeed : -walkSpeed) * delta * walkingToSpeedFactor.x),
            y: actor.node.position.y.near(walkingTo.y) ? 0 : (((walkingTo.y > actor.node.position.y) ? walkSpeed : -walkSpeed) * delta * walkingToSpeedFactor.y)
        )
        
        actor.face(detectDirection(nextPoint: nextPoint))
        
        actor.node.position = Vector2(x:actor.node.position.x + nextPoint.x, y:actor.node.position.y + nextPoint.y)
        
        actor.setAwayScale(awayFactor)
        
        //notifyObjects()
        
        
        if actor.node.position.near(walkingTo, treshold: (fastWalk ? 20 : 15) * Float(Game.shared.scale)) {
            walkTo(position: path.popLast())
        }
        
        if self.walkingTo == nil {
            stopWalk(finalPosition: walkingTo)
        }
    }

    private func stopWalk(finalPosition:Vector2){
        actor.node.position = finalPosition
        actor.stopWalk()
        walkCompletion?()
        walkCompletion = nil
    }
    
    private func getWalkSpeed(awayFactor:Float) -> Float {
        (fastWalk ? Constants.walkSpeed * Constants.fastWalkFactor : Constants.walkSpeed) * awayFactor
    }
    
    private func detectDirection(nextPoint:Vector2) -> Facing {
        
        if nextPoint.y.near(0, treshold: 0.5 * Game.shared.scale) {
            return nextPoint.x > 0 ? .right : .left
        }
        
        if nextPoint.x.near(0, treshold: 0.5 * Game.shared.scale) {
            return nextPoint.y > 0 ? .front : .back
        }
        
        if nextPoint.y > 0 {
            return nextPoint.x > 0 ? .frontRight : .frontLeft
        }
        
        return nextPoint.x > 0 ? .backRight : .backLeft
                
    }
    
    private func calculateMediaVelocity(from:Vector2, to:Vector2?){
        guard let to else { return }
        
        let angle = atan2(to.y - from.y, to.x - from.x)
        
        let xFactor = abs(cos(angle))
        let yFactor = abs(sin(angle))
        let ySpeedFactor =  xFactor * 0.5 + 0.5 //Clamp to [0.5, 1] range
        //print("xVelocity: \(xFactor), yVelocity: \(yFactor), ySpeedFactor: \(ySpeedFactor)")
        self.walkingToSpeedFactor = Vector2(x: xFactor * ySpeedFactor, y: yFactor * ySpeedFactor)
    }
}
