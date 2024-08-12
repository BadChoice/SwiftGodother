import SwiftGodot
import Foundation

@Godot
class MainScene : Node2D {
    
    var room:Room!
    var scanner:ScreenScanner!
    var inventoryUI:InventoryUI!
    var verbWheel:VerbWheel!
    var cursor:Cursor!
    
    var inputHandler:InputHandler!
    
    //MARK: - Setup
    override func _ready() {
                
        initialize()
        
        room = ArcadeEntrance()
        addChild(node: room.node)
        Game.shared.room = room
        room._ready()
        Game.shared.actor = room.actor
        
        addChild(node: scanner.label)
        addChild(node: verbWheel.node)
        addChild(node: inventoryUI.node)
        addChild(node: cursor.node)
        
        inventoryUI.hide()
                
        //getWindow()?.size = getWindow()!.size * Int(Game.shared.scale)
        onViewPortChanged() //Reposition hud
        
        getWindow()?.sizeChanged.connect { [unowned self] in
            onViewPortChanged()
        }
        
        //It sets the base content, so it can scale to 200/1024 before showing black stripes
        getWindow()?.contentScaleSize = Vector2i(x:200, y:1024) * Int(Game.shared.scale)
        
        
        
        //getWindow()?.size = Vector2i(x:4096, y:2048)
        
        room.onEnter()
    }
    
    
    private func initialize(){
        GD.print("DPI: \(DisplayServer.screenGetDpi(screen: -1))")
        GD.print("Screen scale: \(DisplayServer.screenGetScale())")
        
        Game.shared.scale = min(2, DisplayServer.screenGetScale())
        Game.shared.scene = self
        scanner     = ScreenScanner()
        inventoryUI = InventoryUI()
        verbWheel   = VerbWheel()
        cursor      = Cursor()
        Game.shared.talkEngine = TalkEngine()
        
        inputHandler = InputHandler.make()
        inputHandler.scene = self
    }
    
    public func onViewPortChanged(){
        inventoryUI.reposition(room: room)
    }

    //MARK: - Touch
    override func _input(event: InputEvent) {                
        inputHandler._input(event: event)
    }
    
    override func _process(delta: Double) {
        onViewPortChanged()
        Game.shared.actor?._process(delta: delta)
        inputHandler._process(delta:delta)
        
    }
    
    func onLongPress(at position:Vector2){
        guard !Game.shared.touchLocked else { return }
                
        guard let object = inventoryUI.isOpen ? inventoryUI.object(at:position, positionIsLocal: false)?.object : object(at: position) else {
            return
        }
        verbWheel.show(at: position, for:object)
        scanner.show(text: "", at: position)
    }
    
    func onTouched(at position:Vector2){
        guard !Game.shared.touchLocked else { return }
        
        let object = object(at: getLocalMousePosition())
        if verbWheel.onTouched(at: position)  { return }
        if inventoryUI.onTouched(at: position, roomObject:object) { return }
        
        if let object {
            walk(to: object)
        } else {
            walk(to: getLocalMousePosition())
        }
    }
    
    func onMouseMoved(at position:Vector2) {
        
        guard !Game.shared.touchLocked else { return }
        
        let object = object(at: getLocalMousePosition())
                            
        if verbWheel.onMouseMoved(at: position) { return }
        if inventoryUI.onMouseMoved(at: position, roomObject:object) { return }
        
        scanner.onMouseMoved(at: getLocalMousePosition(), object: object)
    }
    
    private func object(at position: Vector2) -> Object? {
        room.objects.first { $0.isTouched(at: position) }
    }
    
    //MARK: - Walk
    private func walk(to destination:Vector2) {
        if let path = room.walkbox.calculatePath(from: room.actor.node.position, to: destination) {
            room.actor.walk(path: path, walkbox: room.walkbox)
            
            if Constants.debug {
                let pathNode = Line2D()
                pathNode.closed = false
                Walkbox.drawPoints(node: pathNode, points: path, color: .yellow, width: 2)
                room.addChild(node: pathNode)
            }            
        }
    }
    
    private func walk(to object:Object){
        Script([
            Walk(to: object),
            Face(object.facing)
        ])
    }
}
