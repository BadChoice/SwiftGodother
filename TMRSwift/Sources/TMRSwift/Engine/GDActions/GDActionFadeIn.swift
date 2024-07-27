import SwiftGodot

class GDActionFadeIn : GDActionAlpha {
        
    init(withDuration duration:Double) {
        super.init(alpha: 1, duration: duration)
    }
    
}
