import SwiftGodot

class PolygonShapedObject : Object {
    
    let node = Line2D()
    var polygon:Polygon!
    
    
    override func centerPoint() -> Vector2 {
        polygon.points.first ?? .zero
        
        return polygon.calculateCentroid()
    }
    
    override func getNode() -> Node2D? {
        var points = details.polygon?.components(separatedBy: " ").chunked(into: 2).map {
            (Vector2(stringLiteral: "\($0[0]) \($0[1])") - Vector2(x:712, y:512)) * Game.shared.scale
        }
        points!.append(points!.first!)
        
        polygon = Polygon(points: points!)
        
        polygon.points.forEach {
            node.addPoint(position: $0)
        }
        
        node.defaultColor = .yellow
        node.width = 4
        if !Constants.debug {
            node.modulate.alpha = 0
        }
        return node
    }
    
    
    override func isTouched(at: Vector2) -> Bool {
        polygon.contains(point: at)
    }
}
