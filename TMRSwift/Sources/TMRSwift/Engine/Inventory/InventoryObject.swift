import SwiftGodot

class InventoryObject {
    let object:Inventoriable
    var sprite:Sprite2D!
    
    init(_ object:Inventoriable){
        self.object = object
    }
    
    func texture() -> Texture2D? {
        let texture = Game.shared.scene.inventoryUI.atlas.textureNamed(object.scripts.inventoryImage)
        if texture == nil {
            GD.printErr("[INVENTORY OBJECT] No texture \(object.scripts.inventoryImage)")
        }
        return texture
    }
    
    func createSprite(){
        if sprite != nil { return }
        guard let texture = texture() else { return }
        sprite = Sprite2D(texture:texture)
    }
}
