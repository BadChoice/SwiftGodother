import SwiftGodot

class GDActionScale : GDActionTween {
    
    let finalScale:Float
    
        
    init(to scale:Float, duration:Double) {
        self.finalScale = scale
        super.init(duration: duration)
    }
    
    
    override func setupTween(_ tween:Tween?){
        tween?.tweenProperty(
            object: node,
            property: "scale",
            finalVal: Variant(Vector2(x:finalScale, y:finalScale)),
            duration: duration
        )?.setEase(timingMode)
    }    
}
