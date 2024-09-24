import Foundation
import SwiftGodot

struct ChangeSprite : CompletableAction {
    
    let node:Sprite2D?
    //let imageName:String
    let texture:Texture2D?
    
    init(node:Sprite2D?, imageName:String){
        self.node = node
        texture   = Self.getTexture(imageName, atlas: Game.shared.room.atlas)
    }
    
    init(object:SpriteObject, imageName:String){
        node    = object.node
        texture = Self.getTexture(imageName, atlas: Game.shared.room.atlas)
    }
    
    init(inventory object:Inventoriable, imageName:String){
        let inventoryObject = inventory.objects.first { $0.object.name == object.name }
        node    = inventoryObject?.sprite
        texture = Game.shared.scene.inventoryUI.atlas.textureNamed("inventory/" + imageName)
    }
    
    static func getTexture(_ imageName:String, atlas:TexturePacker?) -> Texture2D? {
        atlas?.textureNamed(imageName)// ?? SKTexture(imageNamed: imageName)
    }
    
    func run(then: @escaping () -> Void) {
        node?.texture = texture
        then()
    }
}
