import SwiftGodot

class GDActionRepeat : GDAction {
    
    let action:GDAction
    var count:Int
    
    var shouldFinish:Bool = false
    
    init(_ action:GDAction, count:Int){
        self.action = action
        self.count = count
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
        count -= 1
        if count == 0 || shouldFinish { return }
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
