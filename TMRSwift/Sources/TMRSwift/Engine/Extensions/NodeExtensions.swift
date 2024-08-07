import SwiftGodot

extension Node {
    func removeFromParent(){
        getParent()?.removeChild(node: self)
    }
    
    func removeAllChildren(){
        getChildren().forEach { $0.removeFromParent() }
    }
}
