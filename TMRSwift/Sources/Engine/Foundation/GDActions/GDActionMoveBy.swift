import SwiftGodot

class GDActionMoveBy : GDActionTween {
    
    let offset:Vector2
    
        
    init(by offset:Vector2, duration:Double) {
        self.offset = offset
        super.init(duration: duration)
    }
    
    override func setupTween(_ tween:Tween?){
        
        let position = (node as? Sprite2D)?.position ?? (node as? Control)?.getPosition() ?? .zero
        
        tween?.tweenProperty(
            object: node,
            property: "position",
            finalVal: Variant(position + offset),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
    }
}
