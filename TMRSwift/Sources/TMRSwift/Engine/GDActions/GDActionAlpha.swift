import SwiftGodot

class GDActionAlpha : GDActionTween {
    
    let finalAlpha:Float
        
    init(to alpha:Float, duration:Double) {
        self.finalAlpha = alpha
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        tween?.tweenProperty(
            object: node,
            property: "modulate",
            finalVal: Variant(Color(r:1, g:1, b:1, a:finalAlpha)),
            duration: duration
        )?.setEase(timingMode)
    }
        
}
