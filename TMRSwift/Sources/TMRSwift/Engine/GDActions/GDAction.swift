import SwiftGodot

class GDAction {
    func run(_ node:Node2D, completion:(()->Void)?){
        completion?()
    }
    
    //move by delta:Vector duration
    //move by deltaX deltaY duration
    //move to location duration
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

    static func fadeAlpha(to alpha:Float, withDuration duration:Double) -> GDActionAlpha {
        GDActionAlpha(to: alpha, duration: duration)
    }
}

