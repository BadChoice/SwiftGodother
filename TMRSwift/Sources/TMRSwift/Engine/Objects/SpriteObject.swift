import Foundation
import SwiftGodot

class SpriteObject : Object {
    var node:Sprite2D?
    
    @objc dynamic var image:String  { details.image! }
    
    required init(_ details: ObjectDetails? = nil) {
        super.init(details)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        if node?.getParent() == nil { return false }
        return node?.rectInParent().hasPoint(at) ?? false
    }
    
    override func getNode() -> Node? {
        guard let atlas = Game.shared.room.atlas, let sprite = atlas.sprite(name: image) else {
            return nil
        }
        node = sprite
            
        let size = node?.getRect().size ?? .zero        
        
        node?.position = position
        node?.centered = true
        node?.offset = (size / 2)        
        
        return node
    }
}
