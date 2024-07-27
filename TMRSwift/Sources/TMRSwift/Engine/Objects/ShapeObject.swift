import SwiftGodot

class ShapeObject: Object {
    let node = ColorRect()
    
    override init(_ details: ObjectDetails) {
        super.init(details)
                
        let positionVector = Vector2(stringLiteral: details.position! ) - Vector2(x:512, y:512)
        
        node.color = .white
        node.modulate.alpha = 0.2
        node.setSize(Vector2(x: 100, y: 100))
        node.setPosition(positionVector)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        node.getRect().hasPoint(at)
    }
}
