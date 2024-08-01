import SwiftGodot

class ShapeObject: Object {
    let node = ColorRect()
    
    required override init(_ details: ObjectDetails) {
        super.init(details)
                            
        node.color = .white
        node.modulate.alpha = 0.2
        node.setSize(Vector2(x: 100, y: 100) * Game.shared.scale) 
        node.setPosition(position)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        node.getRect().hasPoint(at)
    }
}
