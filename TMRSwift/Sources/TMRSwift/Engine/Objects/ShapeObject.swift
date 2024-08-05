import SwiftGodot

class ShapeObject: Object {
    let node = ColorRect()
    var size:Vector2 {
        guard let size = details.size else { return Vector2(x: 100, y: 100)}
        //TODO: Remove the guard when Polygon and NPC implemented
        return Vector2(stringLiteral: size)
    }
    
    required override init(_ details: ObjectDetails) {
        super.init(details)
                            
        node.color = .yellow
        node.modulate.alpha = Constants.debug ? 0.3 : 0.0
        node.zIndex = 100
        node.setSize(size * Game.shared.scale)
        //node.setPosition(position - Vector2(x: size.x * Float(Game.shared.scale), y:0))
        node.setPosition(
            position - Vector2(x: SketchApp.shared.screenSize.x / 2,  y:0) + Vector2(x:size.x * 2, y:0)
        )
    }
    
    override func isTouched(at: Vector2) -> Bool {
        node.getRect().hasPoint(at)
    }
}
