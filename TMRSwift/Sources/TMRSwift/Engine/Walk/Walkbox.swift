import SwiftGodot

class Walkbox {
    
    let frontScale:Float = 0.8
    let backScale:Float = 0.1
    let footsteps:Footsteps = .concrete
    
    let node = Line2D()
    let points:[Vector2]
    
    init(points:String){
        let values = points.components(separatedBy: " ")
        self.points = values.chunked(into: 2).map {
            Vector2(stringLiteral: "\($0[0]) \($0[1])") - Vector2(x:512, y:512)
        }
        
        Self.drawPoints(node: node, points: self.points, color: .white)
    }
    
    var poly: PackedVector2Array {
        let poly = PackedVector2Array()
        points.forEach { poly.append($0)}
        return poly
    }
    
    static func drawPoints(node:Line2D, points:[Vector2], color:Color, width:Double = 8){
        points.forEach {
            node.addPoint(position: $0)
        }
        node.addPoint(position: points.first!)
        node.defaultColor = color
        node.width = width
    }
    
    //https://www.david-gouveia.com/pathfinding-on-a-2d-polygonal-map
    func calculatePath(from:Vector2, to:Vector2) -> [Vector2]?{
        
        let from = nearestInside(from)
        let to   = nearestInside(to)
        
        var astar = AStar2D()
        
        //Add points
        for (index, point) in points.enumerated() {
            astar.addPoint(id: index, position: point)
        }
        
        //Add conections
        for (index, point) in points.enumerated() {
            var next_index = (index + 1) % points.count
            astar.connectPoints(id: index, toId: next_index)
        }
        
        //Add start and end points inside the astar
        astar.addPoint(id: points.count, position: from)
        astar.addPoint(id: points.count + 1, position: to)
        
        //Connect start and end to all the other polygon points
        connectToAll(astar, pointId: points.count)
        connectToAll(astar, pointId: points.count + 1)
        
        //Connect start and end
        if inLineOfSight(p1: from, p2: to) {
            GD.print("Connecting start and end")
            astar.connectPoints(id: points.count, toId: points.count + 1)
        }
        
        var start_id = astar.getClosestPoint(toPosition: from)
        var end_id   = astar.getClosestPoint(toPosition: to)
                

        let path = astar.getPointPath(fromId: start_id, toId: end_id).map { $0 }
        GD.print(path)
                        
        return path.count == 0 ? [to] : path
    }
    
    private func connectToAll(_ astar:AStar2D, pointId:Int){
        for (index, point) in points.enumerated() {
            if inLineOfSight(p1: point, p2: points[index]) {
                astar.connectPoints(id:pointId, toId: index)
            }
        }
    }
    
    func inLineOfSight(p1:Vector2, p2:Vector2) -> Bool {
        for (index, point) in points.enumerated() {
            var next_index = (index + 1) % points.count
            let result = Geometry2D.segmentIntersectsSegment(fromA: p1, toA: p2, fromB: points[index], toB: points[next_index])
            if let intersectionPoint = Vector2(result){
                return false
            }
        }
        return true
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
