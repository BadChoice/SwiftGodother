import SwiftGodot

class GDActionRepeatForever : GDAction {
    
    let action:GDAction
    var currentSequence:GDActionSequence?
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
        runSequence(node)
    }
    
    private func runSequence(_ node:Node){
        if shouldFinish { return }
        currentSequence = GDActionSequence([action])
        currentSequence?.run(node) { [self] in
            //runSequence(node)
        }
    }
    
    override func stop(){
        super.stop()
        shouldFinish = true
        currentSequence?.stop()
    }
    
}
