import Foundation

class Pickup : CompletableAction {
    
    let object:Inventoriable
    let removeFromScene:Bool
    
    init(_ object:Inventoriable, removeFromScene:Bool = true){
        self.object = object
        self.removeFromScene = removeFromScene
    }
    
    func run(then: @escaping () -> Void) {
        inventory.pickup(object)
        Game.shared.scene.inventoryUI.toggleNode.shake(intensity: 12, duration: 0.8)
        if removeFromScene {
            (object as? SpriteObject)?.node?.removeFromParent()
            (object as? ShapeObject)?.node.removeFromParent()
        }
        then()
    }
}
