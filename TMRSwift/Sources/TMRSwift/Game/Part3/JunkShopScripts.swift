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
            Say("I hope you are completely right with me wandering arround here")
        }
    }
}


