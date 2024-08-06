import SwiftGodot

extension Node {
    func run(_ action:GDAction, completion:(()->Void)? = nil) {
        action.run(self, completion: completion)
    }
}


