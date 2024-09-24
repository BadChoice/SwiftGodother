import Foundation
import SwiftGodot

class GDActionTween : GDAction {
    
    let duration:Double
    var tween:Tween!
    var timingMode:Tween.EaseType = .inOut
    
    init(duration:Double){
        self.duration = duration
    }
    
    
    func withTimingMode(_ mode:Tween.EaseType) -> Self {
        self.timingMode = mode
        return self
    }

    override func run(_ node:Node, completion:(()->Void)? = nil){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        addToList(node: node)
        
        tween = node.createTween()
        setupTween(tween)
        tween?.finished.connect { [self] in
            removeFromList()
            completion?()
        }
    }
        
    func setupTween(_ tween:Tween?){
        
    }
        
    override func stop() {
        super.stop()
        tween?.stop()
    }
}


