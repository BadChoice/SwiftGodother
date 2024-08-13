import SwiftGodot

class GDAction {
    func run(_ node:Node, completion:(()->Void)?){
        completion?()
    }
    
    //move by delta:Vector duration
    //move by deltaX deltaY duration
    
    static func move(to position:Vector2, duration:Double) -> GDActionMoveTo {
        GDActionMoveTo(to: position, duration: duration)
    }
    //moveTo x duration
    //moveTo y duration
    //rotate by angle radians duration
    //rotate toAngle radians duration
    //rotate toAngle radians duration shortestUnitArc:bool
    //scale by scale duration
    //scaleX by xScale, y yScale duration
    //scale to scale duration
    //scaleX to xScale y yScale, duration
    //scaleX to scale duration
    //scaleY to scale duration

    static func scale(to scale:Float, duration:Double) -> GDActionScale {
        GDActionScale(to: scale, duration: duration)
    }
    
    static func sequence(_ actions:[GDAction]) -> GDActionSequence {
        GDActionSequence(actions)
    }
    static func group(_ actions:[GDAction]) -> GDActionGroup {
        GDActionGroup(actions)
    }
    //repeat count: Int
    //repeatForever

    static func fadeIn(withDuration duration:Double) -> GDActionFadeIn {
        GDActionFadeIn(withDuration: duration)
    }
    static func fadeOut(withDuration duration:Double) -> GDActionFadeOut {
        GDActionFadeOut(withDuration: duration)
    }
    
    //fadeAlpha by duration

    static func fadeAlpha(to alpha:Float, duration duration:Double) -> GDActionAlpha {
        GDActionAlpha(to: alpha, duration: duration)
    }
    
    static func wait(forDuration duration:Double) -> GDActionWait {
        GDActionWait(duration: duration)
    }
    
    static func shake(amplitude:Vector2, shakeDuration:Double = 0.02, duration:Double) -> GDActionShake {
        GDActionShake(amplitude: amplitude, shakeDuration: shakeDuration, duration: duration)
    }
}

