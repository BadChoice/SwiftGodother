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
    
    func onTouched(at position:Vector2, roomObject:Object?) -> Bool {
        if let usingObject {
            useInventory(at: position, roomObject:roomObject)
            return true
        }
        
        if isOpen {
            if !inventoryBag.hasPoint(position){
                hide()
                return true
            }
            
            if let object = object(at: position) {
                selectObject(object)
            }
            
            return true
        }
        
        if toggleNode.hasPoint(position){
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
        usingObjectSprite!.position = usingObjectSprite!.position - (Vector2(x: 40, y: 60) * Game.shared.scale)
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
    
    private func useInventory(at position:Vector2, roomObject:Object?){
        defer {
            Game.shared.scene.scanner.show(text: "", at: position)
            deselect()
        }
        
        guard let useWith = findUseWithObject(at: position, roomObject: roomObject) else {
            return
        }
        
        usingObject!.object.onUseWith(useWith, reversed: false)
    }
    
    func onMouseMoved(at position:Vector2, roomObject:Object?) -> Bool {
        guard let objectSprite = usingObjectSprite else {
            if isOpen {
                let object = object(at: position)
                object?.sprite.shake()
                Game.shared.scene.scanner.show(object: object?.object, at: position)
                return true
            }
            return false
        }
        
        if !(inventoryBag.hasPoint(position)) {
            hide()
        }
        
        objectSprite.position = position
        
        if let useWith = findUseWithObject(at: position, roomObject: roomObject) {
            let text = __("Use {object1} with {object2}")
                .replacingOccurrences(of: "{object1}", with:__(usingObject!.object.name))
                .replacingOccurrences(of: "{object2}", with:__(useWith.name))
            bannedIcon.hide()
            Game.shared.scene.scanner.show(text: text, at: position)
        }else{
            bannedIcon.show()
            Game.shared.scene.scanner.show(text: "", at: position)
        }
        
        return true
    }
    
    func object(at position:Vector2) -> InventoryObject? {
        let object = inventory.objects.first {
            $0.sprite?.getParent() != nil && $0.sprite?.hasPoint(position) ?? false
        }
            
        //object?.inventorySprite.simpleShakeOnMouseOver()
        
        return object
    }
    
    private func findUseWithObject(at position:Vector2, roomObject:Object?) -> Object?{
        guard let useWith = isOpen ? object(at:position)?.object : roomObject else {
            return nil
        }
        
        guard usingObject!.object.canBeUsedWith(useWith) || useWith.canBeUsedWith(usingObject!.object) else {
            return nil
        }
        return useWith
    }
    
    func onLongPressed(at position:Vector2) -> Bool {
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
        inventoryBag.position = room.camera.getScreenCenterPosition()
        toggleNode.position = Vector2(
            x:room.camera.getScreenCenterPosition().x - (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y + (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: 120, y: -100) * Game.shared.scale
    }
    
    
    
}
