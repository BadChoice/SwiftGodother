import SwiftGodot

extension Node {
    func removeFromParent(){
        getParent()?.removeChild(node: self)
    }
}
