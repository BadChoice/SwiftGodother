import Foundation

protocol Inventoriable : Object {
    //var inventoryImage:String { get }
}

extension Inventoriable {
    var inInventory: Bool {
        inventory.contains(self)
    }
}

