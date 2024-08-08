import SwiftGodot

class SpriteObject : Object {
    var node:Sprite2D?
    
    
    required init(_ details: ObjectDetails? = nil) {
        super.init(details)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        node?.rectInParent().hasPoint(at) ?? false
    }
    
    override func getNode() -> Node2D? {
        guard let atlas = Game.shared.room.atlas, let sprite = atlas.sprite(name: details.image!) else {
            return nil
        }
        node = sprite
            
        let size = node?.getRect().size ?? .zero        
        
        node?.position = position
        node?.centered = true
        node?.offset = (size / 2)
        node?.zIndex = Int32(details.zPos)
        
        return node
    }
}
