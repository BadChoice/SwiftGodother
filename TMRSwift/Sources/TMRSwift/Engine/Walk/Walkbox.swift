import SwiftGodot

class Walkbox {
    
    let frontScale:Float = 0.8
    let backScale:Float = 0.1
    let footsteps:Footsteps = .concrete
    
    let node = Line2D()
    
    let points:[Vector2] = [
        Vector2(x: -700, y: 250),
        Vector2(x: -300, y: 280),
        Vector2(x: 0, y: -40),
        Vector2(x: 300, y: 150),
        Vector2(x: 700, y: 0),
        Vector2(x: 0, y: 400),
    ]
    
    var poly: PackedVector2Array {
        let poly = PackedVector2Array()
        points.forEach { poly.append($0)}
        return poly
    }
    
    var connections:PackedInt32Array {
        let connections = PackedInt32Array()
        for (index, item) in points.enumerated() {
            connections.append(Int32(index))
        }
        return connections
    }
    
    init() {
        points.forEach {
            node.addPoint(position: $0)
        }
        node.addPoint(position: points.first!)
        node.defaultColor = .red
    }
    
    //https://www.david-gouveia.com/pathfinding-on-a-2d-polygonal-map
    func calculatePath(from:Vector2, to:Vector2) -> [Vector2]?{
        
        let from = nearestInside(from)
        let to   = nearestInside(to)
        
        let finder = PolygonPathFinder()
        finder.setup(points: poly, connections: connections)
        return finder.findPath(from: from, to: to).map { $0 }
    }
    
    func nearestInside(_ point:Vector2) -> Vector2 {
                        
        guard Geometry2D.isPointInPolygon(point:point, polygon:poly) else {
            let distances = points.map {
                Double(abs($0.x - point.x) + abs($0.y - point.y))
            }
            guard let min   = distances.min()               else { return point }
            guard let index = distances.firstIndex(of: min) else { return point }
            return points[index]
        }
        return point
    }
    
    
    // Away scale factor
    public func getAwayScaleForActorAt(point:Vector2) -> Float {
        let screenHeight:Float = 1024
        let factor = (point.y + screenHeight/2) / screenHeight
        return valueBetween(min: backScale, max: frontScale, factor: factor)
    }
    
    func valueBetween(min:Float, max:Float, factor:Float) -> Float {
        (max - min) * factor + min
    }
    
}
