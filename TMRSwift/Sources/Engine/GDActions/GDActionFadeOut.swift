import SwiftGodot

class GDActionFadeOut : GDActionAlpha {
        
    init(withDuration duration:Double, completion:Callable? = nil) {
        super.init(to: 0, duration: duration)
    }
    
}
