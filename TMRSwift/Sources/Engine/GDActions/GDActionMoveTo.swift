import SwiftGodot

class GDActionMoveTo : GDActionTween {
    
    let to:Vector2
    
        
    init(to position:Vector2, duration:Double) {
        self.to = position
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        tween?.tweenProperty(
            object: node,
            property: "position",
            finalVal: Variant(to),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
    }    
}
