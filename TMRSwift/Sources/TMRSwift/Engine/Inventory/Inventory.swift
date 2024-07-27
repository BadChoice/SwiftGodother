import SwiftGodot

class Inventory : HandlesTouch {
    let node = Node2D()
    var toggleNode = Sprite2D()
    var inventory = Sprite2D()
    
    init(){
        node.zIndex = Constants.inventory_zIndex
        
        toggleNode.texture = GD.load(path: "res://assets/ui/inventory-toggle.png")
        inventory.texture = GD.load(path: "res://assets/ui/inventory-open.png")
        
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
        GDActionFadeIn(node: inventory, duration: 0.2).run()
        GDActionScale(node:inventory, scale: 1, duration: 0.2).run()
    }
    
    func close() {
        GDActionFadeOut(node: inventory, duration: 0.2).run()
        GDActionScale(node:inventory, scale: 0, duration: 0.2).run()
    }
    
}
