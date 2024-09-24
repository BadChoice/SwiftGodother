import Foundation
import SwiftGodot

class InputHandler {
    weak var scene:MainScene!
    var pressedAt:Date? = nil
    
    static func make() -> InputHandler {
        if OS.getName() == "iOS" || OS.getName() == "Android" {
            return InputHandlerTouch()
        }
        return InputHandlerMouse()
    }
    
    func _input(event: InputEvent) {
        
    }
    
    func _process(delta: Double) {
        
    }
}
