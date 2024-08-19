import Foundation
import SwiftGodot

class CloseMenuOption: MenuOption {
    
    init() {
        super.init(text: "X")
    }
    
    override func perform() -> Bool {
        true
    }
}
