import Foundation
import SwiftGodot

class InputHandlerTouch : InputHandler {
    
    var fingersOnScreen:Int = 0
    
    
    override func _input(event: InputEvent){

        
        if let touch = event as? InputEventScreenTouch, touch.isPressed() {
            fingersOnScreen = fingersOnScreen + 1
            pressedAt = Date()
            //touches.append(touch.index)
            //onPeriodPressed()
        }
        
        if let touch = event as? InputEventScreenTouch, touch.isReleased() {
            defer { fingersOnScreen -= 1 }
            if fingersOnScreen > 1 {
                return onPeriodPressed()
            }
            return pressedAt == nil ? onLongPressReleased(): onPressed()
        }
        
        if let drag = event as? InputEventScreenDrag {
            return onMouseMoved()
        }
                
        if Game.shared.touchLocked {
            return
        }
                
    }
    
    override func _process(delta: Double) {
        if Game.shared.touchLocked { return }
        guard pressedAt != nil && -pressedAt!.timeIntervalSinceNow > Constants.longPressMinTime else {
            return
        }
        pressedAt = nil
        onLongPress()
    }
    
    //MARK: -
    private func onPeriodPressed(){
        Game.shared.talkEngine.skip()
    }
    
    private func onRightClick(){
        scene.inventoryUI.toggle()
    }
    
    private func onLongPressReleased(){
        scene.verbWheel.onTouched(at: scene.getLocalMousePosition(), shouldHide: false)
    }
    
    private func onPressed(){
        pressedAt = nil
        scene.onTouched(at: scene.getLocalMousePosition())
    }
    
    private func updateCursor(){
        scene.cursor.onMouseMoved(at: scene.getLocalMousePosition())
    }
    
    private func onLongPress(){
        scene.onLongPress(at: scene.getLocalMousePosition())
    }
    
    private func onMouseMoved(){
        scene.onMouseMoved(at: scene.getLocalMousePosition())
    }

    
}
