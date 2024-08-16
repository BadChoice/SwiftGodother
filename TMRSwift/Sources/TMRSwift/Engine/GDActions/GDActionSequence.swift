import SwiftGodot

class GDActionSequence : GDAction {
    
    let actions : [GDAction]
    var completion:(()->Void)?
    var currentIndex = 0
    
    init(_ actions:[GDAction]){
        self.actions = actions
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        self.completion = completion
        addToList(node: node)
        runNext(node)
    }
    
    func runNext(_ node:Node){
        guard node.getParent() != nil else {
            completion?()
            removeFromList()
            return
        }
        
        if currentIndex == actions.count {
            currentIndex = 0
            removeFromList()
            completion?()
            return
        }
        
        addToList(node: node)
        actions[currentIndex].run(node) { [self] in
            currentIndex += 1
            runNext(node)
        }
    }
    
    override func stop() {
        super.stop()
        actions[currentIndex].stop()
    }
}
