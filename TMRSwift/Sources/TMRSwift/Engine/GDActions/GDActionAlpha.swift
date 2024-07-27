import SwiftGodot

class GDActionAlpha {
    
    let node:Node2D
    let duration:Double
    let completion:Callable?
    let finalAlpha:Float
    
    
    init(node:Node2D, alpha:Float, duration:Double, completion:Callable? = nil) {
        self.finalAlpha = alpha
        self.node = node
        self.completion = completion
        self.duration = duration
    }
    
    func run(){
        let tween = node.createTween()
        
        tween?.tweenProperty(
            object: node,
            property: "modulate",
            finalVal: Variant(Color(r:1, g:1, b:1, a:finalAlpha)),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
        
        if let completion {
            tween?.tweenCallback(completion)
        }
    }
    
}
