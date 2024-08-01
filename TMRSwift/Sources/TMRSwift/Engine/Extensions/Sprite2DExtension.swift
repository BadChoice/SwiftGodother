import SwiftGodot

extension Sprite2D {
    
    convenience init(texture:Texture2D) {
        self.init()
        self.texture = texture
    }
    
    func hasPoint(_ point:Vector2) -> Bool {
        rectInParent().hasPoint(point)
    }
    
    func rectInParent() ->  Rect2 {
        (transform * getRect())
    }
    
}
