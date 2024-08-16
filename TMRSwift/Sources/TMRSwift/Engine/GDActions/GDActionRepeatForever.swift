import SwiftGodot

class GDActionRepeatForever : GDAction {
    
    let action:GDAction
    var shouldFinish:Bool = false
    
    init(_ action:GDAction){
        self.action = action
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        addToList(node: node)
        runSequence()
    }
    
    private func runSequence(){
        if shouldFinish { return }
        action.run(node) { [self] in
            runSequence()
        }
    }
    
    override func stop(){
        super.stop()
        shouldFinish = true
        action.stop()
    }
    
}
