import SwiftGodot

class GDActionSetTexture : GDAction {
    
    let texture:Texture2D?
        
    init(_ texture:Texture2D?){
        self.texture = texture
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        guard node.getParent() != nil else {
            completion?()
            return
        }
        
        guard let sprite = node as? Sprite2D else {
            completion?()
            return
        }
        
        if texture == nil {
            completion?()
            return
        }
        
        sprite.texture = texture
        completion?()
    }
    
}
