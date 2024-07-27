import SwiftGodot

extension Sprite2D {
    
    func hasPoint(_ point:Vector2) -> Bool {
        rectInParent().hasPoint(point)
    }
    
    func rectInParent() ->  Rect2 {
        (transform * getRect())
    }
    
}
