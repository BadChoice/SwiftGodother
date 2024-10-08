import SwiftGodot

class GDActionGroup : GDAction {
    
    var actions : [GDAction]
    var completedActions = 0
    var completion:(()->Void)?
    
    init(_ actions:[GDAction]){
        self.actions = actions.reversed()
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        addToList(node: node)
        
        self.completion = completion
        actions.forEach { action in
            action.run(node) { [self] in
                removeFromList()
                onActionCompleted()
            }
        }
    }
    
    func onActionCompleted(){
        completedActions = completedActions + 1
        if completedActions == actions.count {
            completion?()
            completion = nil
        }
    }
    
    override func stop() {
        super.stop()
        actions.forEach { $0.stop() }
        actions = []
    }

}
