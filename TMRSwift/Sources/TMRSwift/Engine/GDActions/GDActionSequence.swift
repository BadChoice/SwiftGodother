import SwiftGodot

class GDActionSequence : GDAction {
    
    var actions : [GDAction]
    var completion:(()->Void)?
    
    init(_ actions:[GDAction]){
        self.actions = actions.reversed()
    }
    
    override func run(_ node:Node2D, completion:(()->Void)? = nil){
        self.completion = completion
        runNext(node)
    }
    
    func runNext(_ node:Node2D){
        guard let action = actions.popLast() else {
            completion?()
            completion = nil
            return
        }
        
        action.run(node) { [unowned self] in
            runNext(node)
        }
    }
}
