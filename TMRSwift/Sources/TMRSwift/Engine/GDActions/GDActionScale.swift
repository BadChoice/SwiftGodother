import SwiftGodot

class GDActionScale : GDAction {
    
    let duration:Double
    let finalScale:Float
        
    init(to scale:Float, duration:Double) {
        self.finalScale = scale
        self.duration = duration
    }
    
    override func run(_ node:Node2D, completion:(()->Void)? = nil){
        let tween = node.createTween()
                
        tween?.tweenProperty(
            object: node,
            property: "scale",
            finalVal: Variant(Vector2(x:finalScale, y:finalScale)),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
        
        tween?.finished.connect {
            completion?()
        }
    }
    
}
