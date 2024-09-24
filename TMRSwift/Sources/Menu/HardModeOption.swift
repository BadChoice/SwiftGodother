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
        Settings.shared.hardMode = !Settings.shared.hardMode
        Settings.shared.save()
        label.text   = Self.getText()        
        return false
    }
    
    static func getText() -> String {
        __("Hard Mode") + ": " + (Settings.shared.hardMode ? __("On") : __("Off"))
    }
    
}
