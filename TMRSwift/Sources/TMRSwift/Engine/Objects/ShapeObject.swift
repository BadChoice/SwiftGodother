import SwiftGodot

class ShapeObject: Object {
    let node = ColorRect()
    var size:Vector2 {
        guard let size = details.size else { return Vector2(x: 100, y: 100)}
        //TODO: Remove the guard when Polygon and NPC implemented
        return Vector2(stringLiteral: size)
    }
    
    required override init(_ details: ObjectDetails? = nil) {
        super.init(details)
                            
        node.color = .yellow
        node.modulate.alpha = Constants.debug ? 0.3 : 0.0
        node.setSize(size * Game.shared.scale)
    }
    
    override func centerPoint() -> Vector2 {
        position + (size * Game.shared.scale / 2)
    }
    
    override func getNode() -> Node {
        node.setPosition(position)
        return node
    }
    
    override func isTouched(at: Vector2) -> Bool {
        node.getRect().hasPoint(at)
    }
}
