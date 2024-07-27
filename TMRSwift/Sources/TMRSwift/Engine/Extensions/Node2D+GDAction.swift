import SwiftGodot

extension Node2D {
    func run(_ action:GDAction, completion:(()->Void)? = nil) {
        action.run(self, completion: completion)
    }
}
