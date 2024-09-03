import SwiftGodot

class InventoryUI {
    let node       = Node2D()
    var toggleNode:Sprite2D!
    var inventoryBag:Sprite2D!
    
    var atlas:TexturePacker
    
    let inventory = Inventory()
    var grid = Grid()
    
    var usingObject:InventoryObject?
    var usingObjectSprite:Sprite2D?
    var bannedIcon:Sprite2D = Sprite2D(path: "res://assets/ui/ban.png")
        
    init(){
        node.zIndex = Constants.inventory_zIndex
        
        toggleNode   = Sprite2D(path: "res://assets/ui/inventory-toggle.png")
        inventoryBag = Sprite2D(path: "res://assets/ui/inventory-open.png")
        
        node.addChild(node: toggleNode)
        node.addChild(node: inventoryBag)
        
        atlas = TexturePacker(path: "res://assets/inventory/TPInventory.atlasc", filename: "TPInventory.plist")
        atlas.load()
        
        inventoryBag.addChild(node: grid.node)
    }
    
    func onTouched(at point:Vector2, roomObject:Object?) -> Bool {
        let localPosition = inventoryBag.toLocal(globalPoint: point)
        if let usingObject {
            useInventory(at: point, roomObject:roomObject)
            return true
        }
        
        if isOpen {
            if !inventoryBag.hasPoint(point){
                hide()
                return true
            }
            
            if let object = object(at: localPosition) {
                selectObject(object)
            }
            
            return true
        }
        
        if toggleNode.hasPoint(point){
            toggle()
            return true
        }
        
        return false
    }
    
    private func selectObject(_ object:InventoryObject) {
        Sound.play(once: "item_take")
        usingObject = object
        usingObjectSprite = object.sprite.duplicate() as! Sprite2D
        usingObjectSprite?.zIndex = Constants.inventory_zIndex
        usingObjectSprite!.position = inventoryBag.toGlobal(localPoint: usingObjectSprite!.position) - (Vector2(x: 40, y: 60) * Game.shared.scale)
        inventoryBag.getParent()?.addChild(node: usingObjectSprite)
        addBannedIcon()
    }
    
    func addBannedIcon(){
        bannedIcon.removeFromParent()
        bannedIcon.zIndex = 1
        bannedIcon.position = Vector2(
            x: usingObjectSprite!.getRect().size.x/2  - (20 * Float(Game.shared.scale)),
            y: -usingObjectSprite!.getRect().size.y/2 + (20 * Float(Game.shared.scale))
        )
        bannedIcon.hide()
        usingObjectSprite?.addChild(node: bannedIcon)
    }
    
    
    private func deselect(){
        Sound.play(once: "item_put")
        usingObjectSprite?.removeFromParent()
        usingObjectSprite = nil
        usingObject = nil
    }
    
    private func useInventory(at point:Vector2, roomObject:Object?){
        defer {
            Game.shared.scene.scanner.show(text: "", at: point)
            deselect()
        }
        
        guard let useWith = findUseWithObject(at: point, roomObject: roomObject) else {
            return
        }
        
        usingObject!.object.onUseWith(useWith, reversed: false)
    }
    
    func onMouseMoved(at point:Vector2, roomObject:Object?) -> Bool {
        let localPosition = inventoryBag.toLocal(globalPoint: point)
        guard let objectSprite = usingObjectSprite else {
            if isOpen {
                let object = object(at: localPosition)
                object?.sprite.shake()
                Game.shared.scene.scanner.show(object: object?.object, at: point)
                return true
            }
            return false
        }
        
        if !(inventoryBag.hasPoint(point)) {
            hide()
        }
        
        objectSprite.position = point
        
        if let useWith = findUseWithObject(at: point, roomObject: roomObject) {
            let text = __("Use {object1} with {object2}")
                .replacingOccurrences(of: "{object1}", with:__(usingObject!.object.name))
                .replacingOccurrences(of: "{object2}", with:__(useWith.name))
            bannedIcon.hide()
            Game.shared.scene.scanner.show(text: text, at: point)
        }else{
            bannedIcon.show()
            Game.shared.scene.scanner.show(text: "", at: point)
        }
        
        return true
    }
    
    func object(at point:Vector2, pointIsLocal:Bool = true) -> InventoryObject? {
        
        let localPosition = pointIsLocal ? point : inventoryBag.toLocal(globalPoint: point)
        
        let object = inventory.objects.first {
            $0.sprite?.getParent() != nil && $0.sprite?.hasPoint(point) ?? false
        }
            
        //object?.inventorySprite.simpleShakeOnMouseOver()
        
        return object
    }
    
    private func findUseWithObject(at point:Vector2, roomObject:Object?) -> Object?{
        guard let useWith = isOpen ? object(at:point)?.object : roomObject else {
            return nil
        }
        
        guard usingObject!.object.canBeUsedWith(useWith) || useWith.canBeUsedWith(usingObject!.object) else {
            return nil
        }
        return useWith
    }
    
    func onLongPressed(at point:Vector2) -> Bool {
        return false
    }
    
    func toggle(){
        isOpen ? hide() : show()
    }
    
    var isOpen:Bool {
        inventoryBag.modulate.alpha == 1
    }
    
    func show(){
        inventoryBag.modulate.alpha = 0
        inventoryBag.scale = Vector2(x: 0, y: 0)
        inventoryBag.run(.group([
            .fadeIn(withDuration: 0.2),
            .scale(to: 1, duration: 0.2)
        ]))          
        
        grid.showObjectsForCurrentPage(inventory.objects)
    }
    
    func hide() {
        if inventoryBag.modulate.alpha == 0 { return }
        inventoryBag.run(.group([
            .fadeOut(withDuration: 0.2),
            .scale(to: 0, duration: 0.2)
        ]))
    }

    
    func reposition(room:Room){
        guard room.camera.enabled else { return }
        inventoryBag.position = room.camera.getScreenCenterPosition()
        toggleNode.position = Vector2(
            x:room.camera.getScreenCenterPosition().x - (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y + (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: 120, y: -100) * Game.shared.scale
    }
    
    
    
}
