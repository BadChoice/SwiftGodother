import SwiftGodot

class InventoryObject {
    let object:Inventoriable
    var sprite:Sprite2D!
    
    init(_ object:Inventoriable){
        self.object = object
    }
    
    func createSprite(){
        if sprite != nil { return }
        guard let texture = Game.shared.scene.inventoryUI.atlas.textureNamed(name: object.inventoryImage) else { return }
        
        sprite = Sprite2D(texture:texture)
        
    }
}
