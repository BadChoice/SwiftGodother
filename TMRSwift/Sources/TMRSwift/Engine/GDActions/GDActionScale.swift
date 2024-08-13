import SwiftGodot

class GDActionScale : GDAction {
    
    let duration:Double
    let finalScale:Float
    
    var timingMode:Tween.EaseType = .inOut
        
    init(to scale:Float, duration:Double) {
        self.finalScale = scale
        self.duration = duration
    }
    
    func withTimingMode(_ mode:Tween.EaseType) -> Self {
        self.timingMode = mode
        return self
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        let tween = node.createTween()
                
        tween?.tweenProperty(
            object: node,
            property: "scale",
            finalVal: Variant(Vector2(x:finalScale, y:finalScale)),
            duration: duration
        )?.setEase(timingMode)
                
        
        tween?.finished.connect {
            completion?()
        }
    }
    
}
