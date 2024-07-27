import SwiftGodot

class GDActionFadeOut : GDActionAlpha {
        
    init(duration:Double, completion:Callable? = nil) {
        super.init(alpha: 0, duration: duration)
    }
    
}
