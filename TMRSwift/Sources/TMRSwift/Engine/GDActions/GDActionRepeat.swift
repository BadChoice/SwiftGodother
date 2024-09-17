import SwiftGodot

class GDActionRepeat : GDAction {
    
    let action:GDAction
    var count:Int
    var completion:(()->Void)?
    var done:Int = 0
    
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
        
        self.completion = completion
        addToList(node: node)
        runSequence()
    }
    
    private func runSequence(){
        done += 1
        
        if done == count {
            done = 0
            completion?()
            completion = nil
            removeFromList()
            return
        }
        
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
