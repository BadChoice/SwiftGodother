import SwiftGodot

class GDActionFadeOut : GDActionAlpha {
        
    init(node:Node2D, duration:Double, completion:Callable? = nil) {
        super.init(node: node, alpha: 0, duration: duration, completion: completion)
    }
    
}
