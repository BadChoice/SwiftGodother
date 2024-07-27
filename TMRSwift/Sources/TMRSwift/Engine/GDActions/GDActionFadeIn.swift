import SwiftGodot

class GDActionFadeIn {
    
    let node:Node2D
    let duration:Double = 0
    let completion:Callable?
    var time:Double = 0
    
    init(node:Node2D, duration:Double, completion:Callable? = nil) {
        self.node = node
        self.completion = completion
    }
    
    func run(){
        let tween = node.createTween()
        
        tween?.tweenProperty(
            object: node,
            property: "modulate",
            finalVal: Variant(Color(r:1, g:1, b:1, a:1)),
            duration: duration
        )?.setEase(Tween.EaseType.inOut)
        
        if let completion {
            tween?.tweenCallback(completion)
        }
    }
    
}
