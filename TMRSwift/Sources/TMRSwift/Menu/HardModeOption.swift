import Foundation
import SwiftGodot

class HardModeOption : Menu.Option {
        
    init(){
        super.init(text: Self.getText())
    }
    
    override func touched(at point: Vector2) -> Bool {
        if label.hasPoint(point){
            return perform(Node())
        }
        return true
    }
    
    override func perform(_ node:Node) -> Bool {
        Settings.hardMode = !Settings.hardMode
        label.text   = Self.getText()

        return false
    }
    
    static func getText() -> String {
        __("Hard Mode") + ": " + (Settings.hardMode ? __("On") : __("Off"))
    }
    
}
