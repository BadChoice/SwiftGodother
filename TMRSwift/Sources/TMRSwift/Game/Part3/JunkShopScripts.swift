import Foundation


extension AncientCube {
    var inventoryImage: String { "todo" }
}

extension WalkieTalkies {
    var inventoryImage: String { "todo" }
}

extension GasTube {
    var inventoryImage: String { "todo" }
    
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("Hello baby")
        }
    }
}


