import SwiftGodot

class GDActionSequence : GDAction {
    
    var actions : [GDAction]
    var completion:(()->Void)?
    
    init(_ actions:[GDAction]){
        self.actions = actions.reversed()
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        self.completion = completion
        runNext(node)
    }
    
    func runNext(_ node:Node){
        guard let action = actions.popLast() else {
            completion?()
            completion = nil
            return
        }
        
        action.run(node) { [self] in
            runNext(node)
        }
    }
}
