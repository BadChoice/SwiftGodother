import SwiftGodot
import Foundation

@Godot
class MainScene : Node2D {
    
    var room:Room!
    var scanner     = ScreenScanner()
    var inventory   = Inventory()
    var verbWheel   = VerbWheel()
    var pressedAt:Date? = nil
    
    //MARK: - Setup
    override func _ready() {
        room = Room()
        addChild(node: room)
        addChild(node: scanner.label)
        addChild(node: verbWheel.node)
        addChild(node: inventory.node)
        
        inventory.close()
        
        onViewPortChanged() //Reposition hud
        
        getWindow()?.sizeChanged.connect { [unowned self] in
            onViewPortChanged()
        }
        
        //It sets the base content, so it can scale to 200/1024 before showing black stripes
        getWindow()?.contentScaleSize = Vector2i(x:200, y:1024)
    }
    
    public func onViewPortChanged(){
        inventory.toggleNode.position = Vector2(
            x: -room.camera.getViewportRect().size.x / 2 + 120,
            y: room.camera.getViewportRect().size.y / 2 - 100
        )
    }
    
    
    //MARK: - Touch
    override func _input(event: InputEvent) {
        if let mouseEvent = event as? InputEventMouseButton, event.isPressed(){
            pressedAt = Date()
        }
        
        if let mouseEvent = event as? InputEventMouseButton, event.isReleased(){
            if pressedAt == nil { return } //It meands long press has been handled
            GD.print("Touch at: \(getLocalMousePosition())")
            pressedAt = nil
            return onTouched(at: getLocalMousePosition())
        }
        
        if let mouseMove = event as? InputEventMouseMotion {
            scanner.onMouseMoved(room:room, at: getLocalMousePosition())
        }
    }
    
    override func _process(delta: Double) {
        if pressedAt != nil && -pressedAt!.timeIntervalSinceNow > Constants.longPressMinTime {
            pressedAt = nil
            onLongPress(at: getLocalMousePosition())
            return
        }
    }
    
    private func onLongPress(at position:Vector2){
        if verbWheel.onLongPressed(at:position) { return }
        inventory.onLongPressed(at:position)
    }
    
    private func onTouched(at position:Vector2){
        if verbWheel.onTouched(at:position)  { return }
        if inventory.onTouched(at: position) { return }
        
        walk(to: getLocalMousePosition())
    }
    
    
    //MARK: - Walk
    private func walk(to destination:Vector2) {
        if let path = room.walkbox.calculatePath(from: room.player.position, to: destination) {
            room.player.walk(path: path, walkbox: room.walkbox)
            
            if Constants.debug {
                let pathNode = Line2D()
                pathNode.closed = false
                Walkbox.drawPoints(node: pathNode, points: path, color: .yellow, width: 2)
                room.addChild(node: pathNode)
            }            
        }
    }
}
