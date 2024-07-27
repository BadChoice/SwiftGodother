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
        GD.print("SHOW INVENTORY")
        //inventory.modulate.alpha = 0
        //GDActionFadeIn(node: toggleNode, duration: 1).run()
        inventory.modulate.alpha = 1
    }
    
    func close() {
        inventory.modulate.alpha = 0
    }
    
}
