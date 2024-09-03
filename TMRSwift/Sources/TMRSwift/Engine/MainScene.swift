import SwiftGodot
import Foundation

@Godot
class MainScene : Node2D {
    
    var room:Room!
    var scanner:ScreenScanner!
    var inventoryUI:InventoryUI!
    var hotspots:Hotspots!
    var verbWheel:VerbWheel!
    var cursor:Cursor!
    var menu:Menu!
    
    var inputHandler:InputHandler!
    
    //MARK: - Setup
    override func _ready() {
                
        initialize()
        
        Debug.setDebugGameState()
        
        room = (Debug.roomType ?? ArcadeEntrance.self).init()
        addChild(node: room.node)
        room._ready()
        
        addChild(node: scanner.label)
        addChild(node: verbWheel.node)
        addChild(node: inventoryUI.node)
        addChild(node: cursor.node)
        addChild(node: hotspots.node)
        addChild(node: menu.node)
        
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
        GD.print("[Game] DPI: \(DisplayServer.screenGetDpi(screen: -1))")
        GD.print("[Game] Screen scale: \(DisplayServer.screenGetScale())")
        
        Game.shared.scale = min(2, DisplayServer.screenGetScale())
        Game.shared.scene = self
        scanner      = ScreenScanner()
        inventoryUI  = InventoryUI()
        verbWheel    = VerbWheel()
        cursor       = Cursor()
        hotspots     = Hotspots()
        menu         = Menu()
        
        Game.shared.talkEngine = TalkEngine()
        
        inputHandler = InputHandler.make()
        inputHandler.scene = self
    }
    
    public func onViewPortChanged(){
        inventoryUI.reposition(room: room)
        hotspots.reposition(room: room)
        menu.reposition(room: room)
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
    
    func onLongPress(at point:Vector2){
        guard !Game.shared.touchLocked else { return }
        guard Game.shared.currentYack == nil else { return }
                
        guard let object = inventoryUI.isOpen ? inventoryUI.object(at:point, pointIsLocal: false)?.object : object(at: point) else {
            return
        }
        verbWheel.show(at: point, for:object)
        scanner.show(text: "", at: point)
    }
    
    func onTouched(at point:Vector2){
        guard !Game.shared.touchLocked else { return }
        
        if let yack = Game.shared.currentYack {
            return yack.onTouched(at: point)
        }
        
        let object = object(at: getLocalMousePosition())
        if menu.onTouched(at: point)      { return }
        if verbWheel.onTouched(at: point) { return }
        if hotspots.onTouched(at: point)  { return }
        if inventoryUI.onTouched(at: point, roomObject:object) { return }
        
        if let object {
            walk(to: object)
        } else {
            walk(to: getLocalMousePosition())
        }
    }
    
    func onMouseMoved(at point:Vector2) {
        
        guard !Game.shared.touchLocked else { return }
        
        guard !menu.isShowing else { return }
        
        if let yack = Game.shared.currentYack {
            return yack.onMouseMoved(at: position)
        }
        
        let object = object(at: getLocalMousePosition())
                            
        if verbWheel.onMouseMoved(at: point) { return }
        if inventoryUI.onMouseMoved(at: point, roomObject:object) { return }
        
        scanner.onMouseMoved(at: getLocalMousePosition(), object: object)
    }
    
    private func object(at point: Vector2) -> Object? {
        room.objects.first { $0.isTouched(at: point) }
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
        if let door = object as? ChangesRoom {
            door.goThrough()
            return
        }
        
        Script([
            Walk(to: object),
            Face(object.facing)
        ])
    }
}
