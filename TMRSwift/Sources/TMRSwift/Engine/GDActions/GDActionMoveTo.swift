import SwiftGodot

class GDActionMoveTo : GDAction {
    
    let duration:Double
    let to:Vector2
        
    init(to position:Vector2, duration:Double) {
        self.to = position
        self.duration = duration
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){        
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
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
