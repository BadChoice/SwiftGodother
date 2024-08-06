import SwiftGodot
import Foundation

@Godot
class MainScene : Node2D {
    
    var room:Room!
    var scanner:ScreenScanner!
    var inventory:Inventory!
    var verbWheel:VerbWheel!
    var pressedAt:Date? = nil
    
    //MARK: - Setup
    override func _ready() {
                
        initialize()
        
        room = JunkShop()
        addChild(node: room.node)
        Game.shared.room = room
        room._ready()        
        
        addChild(node: scanner.label)
        addChild(node: verbWheel.node)
        addChild(node: inventory.node)
        
        inventory.close()
                
        //getWindow()?.size = getWindow()!.size * Int(Game.shared.scale)
        onViewPortChanged() //Reposition hud
        
        getWindow()?.sizeChanged.connect { [unowned self] in
            onViewPortChanged()
        }
        
        //It sets the base content, so it can scale to 200/1024 before showing black stripes
        getWindow()?.contentScaleSize = Vector2i(x:200, y:1024) * Int(Game.shared.scale)
    }
    
    
    private func initialize(){
        GD.print("DPI: \(DisplayServer.screenGetDpi(screen: -1))")
        GD.print("Screen scale: \(DisplayServer.screenGetScale())")
        
        Game.shared.scale = min(2, DisplayServer.screenGetScale())
        Game.shared.scene = self
        scanner = ScreenScanner()
        inventory = Inventory()
        verbWheel = VerbWheel()
        Game.shared.talkEngine = TalkEngine()
    }
    
    public func onViewPortChanged(){
        inventory.reposition(room: room)
    }

    //MARK: - Touch
    override func _input(event: InputEvent) {
        if let mouseEvent = event as? InputEventMouseButton, event.isPressed(){
            pressedAt = Date()
        }
        
        if let mouseEvent = event as? InputEventMouseButton, event.isReleased(){
            if pressedAt == nil {  //It meands long press has been handled
                verbWheel.onTouched(at: getLocalMousePosition(), shouldHide: false)
                return
            }
            pressedAt = nil
            return onTouched(at: getLocalMousePosition())
        }
        
        if let mouseMove = event as? InputEventMouseMotion {
            onMouseMoved(at: getLocalMousePosition())
        }
    }
    
    override func _process(delta: Double) {
        onViewPortChanged()
        
        if pressedAt != nil && -pressedAt!.timeIntervalSinceNow > Constants.longPressMinTime {
            pressedAt = nil
            onLongPress(at: getLocalMousePosition())
            return
        }
    }
    
    private func onLongPress(at position:Vector2){

        //inventory.onLongPressed(at: position)
        
        guard let object = object(at: position) else {
            return
        }
        verbWheel.show(at: position, for:object)
    }
    
    private func onTouched(at position:Vector2){
        if verbWheel.onTouched(at: position)  { return }
        if inventory.onTouched(at: position) { return }
        
        walk(to: getLocalMousePosition())
    }
    
    private func onMouseMoved(at position:Vector2) {
        if verbWheel.onMouseMoved(at: position) { return }
        scanner.onMouseMoved(at: getLocalMousePosition(), object: object(at: getLocalMousePosition()))
    }
    
    private func object(at position: Vector2) -> Object? {
        room.objects.first { $0.isTouched(at: position) }
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
