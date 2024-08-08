import Foundation


extension AncientCube {
    static var isCompleted : Bool {
        Self.hasYouthWater && Self.hasZombiePart
    }
    
    var inventoryImage: String {
        if Self.isCompleted   { return "AncientCubeCompleted"}
        if Self.hasYouthWater { return "AncientCubeWithWater" }
        if Self.hasZombiePart { return "AncientCube" }
        return "AncientCube"
    }
}

extension WalkieTalkies {
    var inventoryImage: String {
        if Self.placedAtPizza || Self.placedAtMassage { return "WalkieTalkie" }
        return "WalkieTalkies"
    }
    
    override func combinesWith() -> [Object.Type] {
        [GasTube.self, JunkShopTv.self]
    }
}

extension GasTube {
    override var name: String {
        if Self.hasYouthWater {return "gas tank with youth water" }
        if Self.placedAtCave { return "gas tank" }
        return "gas tank with a tube"
    }
    
    var inventoryImage: String {
        if Self.hasYouthWater {return "GasTubeWithYouthWater" }
        if Self.placedAtCave { return "GasTubeWithoutTube" }
        return "GasTube"
    }
    
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("Hello baby")
            Say("I hope you are completely right with me wandering arround here")
        }
    }
}


