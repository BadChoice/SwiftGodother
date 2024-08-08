import SwiftGodot

class GDActionAlpha : GDAction {
    
    let duration:Double
    let finalAlpha:Float
        
    init(to alpha:Float, duration:Double) {
        self.finalAlpha = alpha
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
            property: "modulate",
            finalVal: Variant(Color(r:1, g:1, b:1, a:finalAlpha)),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
        
        tween?.finished.connect {
            completion?()
        }
    }
    
}
