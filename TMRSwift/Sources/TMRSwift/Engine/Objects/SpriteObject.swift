import SwiftGodot

class SpriteObject : Object {
    var node:Sprite2D?
    
    required init(_ details: ObjectDetails) {
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
        
        GD.print("Node size \(node?.getRect().size)")
        let size = node?.getRect().size ?? .zero
        //node?.position = position - ((node?.getRect().size ?? Vector2.zero) * Game.shared.scale)
        node?.position   = position
        node?.zIndex = Int32(details.zPos)
        node?.rotationDegrees = -90
        node?.centered = false
        return node
    }
}
