import SwiftGodot

class Inventory {
    let node       = Node2D()
    var toggleNode:Sprite2D!
    var inventory:Sprite2D!
    
    init(){
        node.zIndex = Constants.inventory_zIndex
        
        toggleNode = Sprite2D(path: "res://assets/ui/inventory-toggle.png")
        inventory  = Sprite2D(path: "res://assets/ui/inventory-open.png")
        
        node.addChild(node: toggleNode)
        node.addChild(node: inventory)
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if isOpen {
            if !inventory.hasPoint(position){
                GD.print("touched outside inventory")
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
    
    func onLongPressed(at position:Vector2) -> Bool {
        return false
    }
    
    func toggle(){
        isOpen ? close() : open()
    }
    
    var isOpen:Bool {
        inventory.modulate.alpha == 1
    }
    
    func open(){
        inventory.modulate.alpha = 0
        inventory.scale = Vector2(x: 0, y: 0)
        inventory.run(.group([
            .fadeIn(withDuration: 0.2),
            .scale(to: 1, duration: 0.2)
        ]))                
    }
    
    func close() {
        inventory.run(.group([
            .fadeOut(withDuration: 0.2),
            .scale(to: 0, duration: 0.2)
        ]))
    }
    
    func reposition(room:Room){
        inventory.position = room.camera.getScreenCenterPosition()
        toggleNode.position = Vector2(
            x:room.camera.getScreenCenterPosition().x - (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y + (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: 120, y: -100) * Game.shared.scale
    }
    
}
