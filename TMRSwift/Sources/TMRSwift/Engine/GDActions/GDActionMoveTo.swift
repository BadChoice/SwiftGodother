import SwiftGodot

class GDActionMoveTo : GDAction {
    
    let duration:Double
    let to:Vector2
        
    init(to position:Vector2, duration:Double) {
        self.to = position
        self.duration = duration
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        let tween = node.createTween()
                
        tween?.tweenProperty(
            object: node,
            property: "position",
            finalVal: Variant(to),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
                
        
        tween?.finished.connect {
            completion?()
        }
    }
    
}
