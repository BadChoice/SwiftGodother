import SwiftGodot

extension Node {
    func run(_ action:GDAction, completion:(()->Void)? = nil) {
        action.run(self, completion: completion)
    }
    
    func removeAllActions(){
        actions()?.forEach { $0.stop() }
    }
    
    func actions() -> [GDAction]? {
        GDAction.activeActions[getInstanceId()]
    }
    
    func hasActions() -> Bool {
        (actions()?.count ?? 0) > 0
    }
}
