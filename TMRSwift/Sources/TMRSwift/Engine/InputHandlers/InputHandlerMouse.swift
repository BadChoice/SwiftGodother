import Foundation
import SwiftGodot

class InputHandlerMouse : InputHandler {
        
    override func _input(event: InputEvent){
        if let mouseMove = event as? InputEventMouseMotion {
            updateCursor()
        }
        
        if let keyInput = event as? InputEventKey, keyInput.keycode == .period, keyInput.isReleased() {
            return onPeriodPressed()
        }
        
        if Game.shared.touchLocked {
            return
        }
        
        if let mouseEvent = event as? InputEventMouseButton, event.isPressed(), mouseEvent.buttonIndex == .right {
            return onRightClick()
        }
        
        if let mouseEvent = event as? InputEventMouseButton, event.isPressed(){
            pressedAt = Date()
        }
        
        if let mouseEvent = event as? InputEventMouseButton, event.isReleased(){
            return pressedAt == nil ? onLongPressReleased(): onPressed()
        }
        
        if let mouseMove = event as? InputEventMouseMotion {
            onMouseMoved()
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
