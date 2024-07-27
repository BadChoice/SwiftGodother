import SwiftGodot

class GDActionScale {
    
    let node:Node2D
    let duration:Double
    let completion:Callable?
    let finalScale:Float
    
    
    init(node:Node2D, scale:Float, duration:Double, completion:Callable? = nil) {
        self.finalScale = scale
        self.node = node
        self.completion = completion
        self.duration = duration
    }
    
    func run(){
        let tween = node.createTween()
        
        
        tween?.tweenProperty(
            object: node,
            property: "scale",
            finalVal: Variant(Vector2(x:finalScale, y:finalScale)),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
        
        if let completion {
            tween?.tweenCallback(completion)
        }
    }
    
}
