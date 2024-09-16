import Foundation
import SwiftGodot

struct ReloadInventory : CompletableAction {
    
    let object:Inventoriable
    
    init(_ object:Inventoriable){
        self.object = object
    }
    
    init(_ object:ObjectScripts) {
        self.init(object.scriptedObject as! Inventoriable)
    }
        
    func run(then: @escaping () -> Void) {
        let inventoryObject = inventory.objects.first { $0.object.name == object.name }
        let node        = inventoryObject?.sprite
        
        if let texture = inventoryObject?.texture() {   //Resize?
            node?.texture = texture
        }
        /*node?.run(.setTexture(
            InventoryAtlas.shared.atlas.textureNamed(object.inventoryImage),
            resize: true)
        )*/
        then()
    }
}
