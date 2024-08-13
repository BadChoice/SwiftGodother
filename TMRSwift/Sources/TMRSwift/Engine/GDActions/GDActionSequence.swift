import SwiftGodot

class GDActionSequence : GDAction {
    
    var actions : [GDAction]
    var completion:(()->Void)?
    var current:GDAction?
    
    init(_ actions:[GDAction]){
        self.actions = actions.reversed()
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        self.completion = completion
        runNext(node)
    }
    
    func runNext(_ node:Node){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        guard let action = actions.popLast() else {
            completion?()
            completion = nil
            return
        }
        
        addToList(node: node)
        current = action
        action.run(node) { [self] in
            removeFromList()
            runNext(node)
        }
    }
    
    override func stop() {
        super.stop()
        current?.stop()
        actions = []
    }
}
