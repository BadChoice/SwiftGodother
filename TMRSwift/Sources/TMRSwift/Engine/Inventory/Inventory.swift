import SwiftGodot

class Inventory : HandlesTouch {
    let node = Node2D()
    var toggleNode = TextureButton()
    var inventory = TextureButton()
    
    init(){
        node.zIndex = Constants.inventory_zIndex
        
        toggleNode.textureNormal = GD.load(path: "res://assets/ui/inventory-toggle.png")
        
        //toggleNode.setAnchorsPreset(.bottomLeft)
        //toggleNode.offsetLeft = Double(toggleNode.textureNormal!.getSize().x / 2)
        //toggleNode.offsetTop = -Double(toggleNode.textureNormal!.getSize().y)
        
        inventory.textureNormal = GD.load(path: "res://assets/ui/inventory-open.png")
        inventory.offsetLeft = Double(-(inventory.textureNormal?.getSize().x)! / 2)
        inventory.offsetTop = Double(-(inventory.textureNormal?.getSize().y)! / 2)
        inventory.setAnchorsPreset(.center)
        
        node.addChild(node: toggleNode)
        node.addChild(node: inventory)
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if isOpen {
            if !inventory.getRect().hasPoint(position){
                GD.print("touched outside inventory")
                close()
            }
            return true
        }
        
        if toggleNode.getRect().hasPoint(position){
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
        inventory.modulate.alpha = 1
    }
    
    func close() {
        inventory.modulate.alpha = 0
    }
    
}
