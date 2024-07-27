import Foundation
import SwiftGodot

class Walk {
    
    var path:[Vector2]
    let player:Player
    var walkingTo:Vector2?
    let walkbox:Walkbox
    var walkingToSpeedFactor = Vector2(x: 1, y: 1)
    var walkCompletion:(()->Void)?
    
    init(path:[Vector2], player:Player, walkbox:Walkbox){
        self.path = path.reversed()
        self.player = player
        self.walkbox = walkbox
    }
    
    public func walk(then:(()->Void)? = nil){
        
        if let to = path.first, player.position.near(to) {
            player.position = to
            then?()
            return
        }
        
        //GD.print(path)
        
        walkCompletion = then
        walkTo(position: self.path.popLast())
        player.playFootsteps()
    }
    
    private func walkTo(position:Vector2?){
        walkingTo = position
        calculateMediaVelocity(from: player.position, to: position)
    }
    
    public func update(delta:Float) {
        guard let walkingTo else { return }
        
        let awayFactor = walkbox.getAwayScaleForActorAt(point: player.position)
        
        let walkSpeed:Float = getWalkSpeed(awayFactor:awayFactor)
        
        let nextPoint = Vector2(
            x: player.position.x.near(walkingTo.x) ? 0 : (((walkingTo.x > player.position.x) ? walkSpeed : -walkSpeed) * delta * walkingToSpeedFactor.x),
            y: player.position.y.near(walkingTo.y) ? 0 : (((walkingTo.y > player.position.y) ? walkSpeed : -walkSpeed) * delta * walkingToSpeedFactor.y)
        )
        
        player.face(detectDirection(nextPoint: nextPoint))
        
        player.position = Vector2(x:player.position.x + nextPoint.x, y:player.position.y + nextPoint.y)
        
        player.scale = Vector2(x: awayFactor, y:awayFactor)
        
        //notifyObjects()
        
        
        if player.position.near(walkingTo, treshold:15 /*treshold: fastWalk ? 20 : 15*/) {
            walkTo(position: path.popLast())
        }
        
        if self.walkingTo == nil {
            stopWalk(finalPosition: walkingTo)
        }
    }

    private func stopWalk(finalPosition:Vector2){
        player.position = finalPosition
        player.stopWalk()
        walkCompletion?()
        walkCompletion = nil
    }
    
    private func getWalkSpeed(awayFactor:Float) -> Float {
        //let awayFactor = player.scale.y < 0.7 ? max(0.3, player.scale.y) : 1
        //return (walk.fastWalk ? Constants.walkSpeed * Constants.fastWalkFactor : Constants.walkSpeed) * Float(awayFactor)
        return Constants.walkSpeed * awayFactor
    }
    
    private func detectDirection(nextPoint:Vector2) -> Facing {
        
        if nextPoint.y.near(0, treshold: 0.5) {
            return nextPoint.x > 0 ? .right : .left
        }
        
        if nextPoint.x.near(0, treshold: 0.5) {
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
