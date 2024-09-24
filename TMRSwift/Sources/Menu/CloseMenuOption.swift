import Foundation
import SwiftGodot

class CloseMenuOption: Menu.Option {
    
    init() {
        super.init(text: "X")
    }
    
    override func perform(_ node:Node) -> Bool {
        true
    }
    
}
