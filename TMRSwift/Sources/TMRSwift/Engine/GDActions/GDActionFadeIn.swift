import SwiftGodot

class GDActionFadeIn : GDActionAlpha {
        
    init(node:Node2D, duration:Double, completion:Callable? = nil) {
        super.init(node: node, alpha: 1, duration: duration, completion: completion)
    }
    
}
