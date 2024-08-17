import SwiftGodot

class GDActionAlpha : GDActionTween {
    
    let finalAlpha:Float
        
    init(to alpha:Float, duration:Double) {
        self.finalAlpha = alpha
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        
        var color = (node as? Sprite2D)?.modulate ?? Color(r:1, g:1, b:1, a:1)
        color.alpha = finalAlpha
        
        tween?.tweenProperty(
            object: node,
            property: "modulate",
            finalVal: Variant(color),
            duration: duration
        )?.setEase(timingMode)
    }
        
}
