import SwiftGodot

class GDActionFadeIn : GDActionAlpha {
        
    init(withDuration duration:Double) {
        super.init(to: 1, duration: duration)
    }
    
}
