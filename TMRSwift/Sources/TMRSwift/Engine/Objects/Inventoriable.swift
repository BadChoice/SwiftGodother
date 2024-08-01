import Foundation
import SpriteKit

protocol Inventoriable : Object {
    var inventoryImage:String { get }
}

extension Inventoriable {
    var inInventory: Bool {
        false
        //inventory.contains(self)
    }
}

