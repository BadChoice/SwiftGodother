import SwiftGodot

class GDActionRotate : GDActionTween {
    
    let to:Double
            
    init(to radians:Double, duration:Double) {
        self.to = -radians
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        tween?.tweenProperty(
            object: node,
            property: "rotation",
            finalVal: Variant(to),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
    }
}
