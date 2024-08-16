import SwiftGodot

class GDActionRepeat : GDAction {
    
    let action:GDAction
    var count:Int
    
    var currentSequence:GDActionSequence?
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
        runSequence(node)
    }
    
    private func runSequence(_ node:Node){
        count -= 1
        if count == 0 || shouldFinish { return }
        currentSequence = GDActionSequence([action])
        currentSequence?.run(node) { [self] in
            runSequence(node)
        }
    }
    
    override func stop(){
        super.stop()
        shouldFinish = true
        currentSequence?.stop()
    }
    
}
