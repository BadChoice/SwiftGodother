import SwiftGodot

class InventoryObject {
    let object:Inventoriable
    var sprite:Sprite2D!
    
    init(_ object:Inventoriable){
        self.object = object
    }
    
    func texture() -> Texture2D? {
        Game.shared.scene.inventoryUI.atlas.textureNamed(name: object.inventoryImage)
    }
    
    func createSprite(){
        if sprite != nil { return }
        guard let texture = texture() else { return }
        sprite = Sprite2D(texture:texture)
    }
}
