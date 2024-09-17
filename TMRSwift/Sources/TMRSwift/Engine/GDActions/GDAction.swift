import SwiftGodot

class GDAction {
    
    static var activeActions:[UInt:[GDAction]] = [:]
    static var idCounter:UInt = 0
    
    let id:UInt
    weak var node:Node!
    
    init(){
        id = GDAction.idCounter + 1
        GDAction.idCounter += 1
    }
    
    func run(_ node:Node, completion:(()->Void)?){
        completion?()
    }
    
    func stop(){
        removeFromList()
    }
    
    func addToList(node:Node){
        self.node = node
        let nodeId = node.getInstanceId()
        if GDAction.activeActions[nodeId] == nil {
            GDAction.activeActions[nodeId] = []
        }
        GDAction.activeActions[nodeId]?.append(self)
    }
    
    func removeFromList(){
        guard let nodeId = node?.getInstanceId() else { return }
        guard let index = (GDAction.activeActions[nodeId]?.firstIndex { $0.id == id }) else { return }
        GDAction.activeActions[nodeId]?.remove(at: index)
    }
       
    //---------------------------------------------------------------
    // ACTIONS
    //---------------------------------------------------------------
    //move by delta:Vector duration
    //move by deltaX deltaY duration
    static func moveBy(x:Float = 0, y:Float = 0, duration:Double) -> GDActionMoveBy {
        GDActionMoveBy(by: Vector2(x:x, y:y), duration: duration)
    }
    
    static func move(to position:Vector2, duration:Double) -> GDActionMoveTo {
        GDActionMoveTo(to: position, duration: duration)
    }
    //moveTo x duration
    //moveTo y duration
    //rotate by angle radians duration
    //rotate toAngle radians duration
    static func rotate(toAngle radians:Double, duration:Double) -> GDActionRotate {
        GDActionRotate(to: radians, duration: duration)
    }
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

    static func repeatCount(_ action:GDAction, count:Int) -> GDActionRepeat {
        GDActionRepeat(action, count:count)
    }
    
    static func repeatForever(_ action:GDAction) -> GDActionRepeatForever {
        GDActionRepeatForever(action)
    }

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
    
    static func animateForever(_ textures:[Texture2D], timePerFrame:Double) -> GDActionAnimateForever {
        GDActionAnimateForever(textures, timePerFrame: timePerFrame)
    }
    
    static func animate(_ textures:[Texture2D], timePerFrame:Double) -> GDActionAnimate {
        GDActionAnimate(textures, timePerFrame: timePerFrame)
    }
}

