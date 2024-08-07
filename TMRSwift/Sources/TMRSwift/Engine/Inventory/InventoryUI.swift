import SwiftGodot

class InventoryUI {
    let node       = Node2D()
    var toggleNode:Sprite2D!
    var inventoryBag:Sprite2D!
    
    var atlas:TexturePacker
    
    let inventory = Inventory()
    var grid = Grid()
        
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
    
    func onTouched(at position:Vector2) -> Bool {
        if isOpen {
            if !inventoryBag.hasPoint(position){
                close()
            }
            return true
        }
        
        if toggleNode.hasPoint(position){
            toggle()
            return true
        }
        
        return false
    }
    
    func object(at position:Vector2) -> InventoryObject? {
        let object = inventory.objects.first {
            $0.sprite?.getParent() != nil && $0.sprite?.hasPoint(position) ?? false
        }
            
        //object?.inventorySprite.simpleShakeOnMouseOver()
        
        return object
    }
    
    func onLongPressed(at position:Vector2) -> Bool {
        return false
    }
    
    func toggle(){
        isOpen ? close() : open()
    }
    
    var isOpen:Bool {
        inventoryBag.modulate.alpha == 1
    }
    
    func open(){
        inventoryBag.modulate.alpha = 0
        inventoryBag.scale = Vector2(x: 0, y: 0)
        inventoryBag.run(.group([
            .fadeIn(withDuration: 0.2),
            .scale(to: 1, duration: 0.2)
        ]))          
        
        grid.showObjectsForCurrentPage(inventory.objects)
    }
    
    func close() {
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
