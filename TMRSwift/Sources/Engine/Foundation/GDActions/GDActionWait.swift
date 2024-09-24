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
        
        addToList(node: node)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [self] in
            guard node.getParent() != nil else {
                return
            }
            removeFromList()
            completion?()
        }
    }
    
}
