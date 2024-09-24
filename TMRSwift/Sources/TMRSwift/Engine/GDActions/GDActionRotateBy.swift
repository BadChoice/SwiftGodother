import SwiftGodot

class GDActionRotateBy : GDActionTween {
    
    let by:Double
            
    init(_ radians:Double, duration:Double) {
        self.by = -radians
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        
        let finalRotation = ((node as? Sprite2D)?.rotation ?? 0) + by
        
        tween?.tweenProperty(
            object: node,
            property: "rotation",
            finalVal: Variant(finalRotation),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
    }
}
