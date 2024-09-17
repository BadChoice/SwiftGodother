import Foundation
import SwiftGodot

class SpriteObject : Object {
    var node:Sprite2D?
    var polygon:Polygon?
    
    
    required init(_ details: ObjectDetails? = nil) {
        super.init(details)
    }
    
    override func centerPoint() -> Vector2 {
        position + ((node?.getRect().size ?? .zero) / 2)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        if node?.getParent() == nil { return false }
        
        if let polygon {
            return polygon.contains(point: at)
        }
                
        return node?.rectInParent().hasPoint(at) ?? false
    }
    
    override func getNode() -> Node? {        
        if let node { return node }
        
        createNode()
        
        let size = node?.getRect().size ?? .zero
        
        node?.position = position
        node?.centered = true
        node?.offset = (size / 2)
        
        return node
    }
    
    func createNode(){
        guard let atlas = Game.shared.room.atlas, let sprite = atlas.sprite(name: image) else {
            return
        }
        node = sprite
                    
        createShapePolygon()
    }
    
    private func createShapePolygon() {
        var points = details.polygon?.components(separatedBy: " ").chunked(into: 2).map {
            (Vector2(stringLiteral: "\($0[0]) \($0[1])") - Vector2(x:712, y:512)) * Game.shared.scale
        }
        
        if var points {
            points.append(points.first!)
            polygon = Polygon(points: points)
        }
        
    }
}
