import SwiftGodot

class GDActionFadeIn : GDActionAlpha {
        
    init(duration:Double) {
        super.init(alpha: 1, duration: duration)
    }
    
}
