import SwiftGodot
import Foundation

class GDActionWait : GDAction {

    let duration:Double
    
    init(duration:Double){
        self.duration = duration
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard node.getParent() != nil else {
                return
            }
            completion?()
        }
    }
    
}
