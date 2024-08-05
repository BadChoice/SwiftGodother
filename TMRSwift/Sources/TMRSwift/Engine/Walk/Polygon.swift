import SwiftGodot


struct Polygon {
    
    var points:[Vector2]
    
    var polygon: PackedVector2Array {
        let polygon = PackedVector2Array()
        points.forEach { polygon.append($0)}
        polygon.append(points.first!)
        return polygon
    }
    
    func buildGraph(from:Vector2, to:Vector2) -> AStar.Graph {
        //var concavePoints = findConcaveVertices()
        var concavePoints = points
        concavePoints.append(from)
        concavePoints.append(to)
        let edges  = findVerticesInLineOfSight(concavePoints)
        return AStar.Graph(points:points, conections: edges)
    }
    
    func nearestInside(_ point:Vector2) -> Vector2 {
        guard Geometry2D.isPointInPolygon(point:point, polygon:polygon) else {
            let distances = points.map {
                Double(abs($0.x - point.x) + abs($0.y - point.y))
            }
            guard let min   = distances.min()               else { return point }
            guard let index = distances.firstIndex(of: min) else { return point }
            return points[index]
        }
        return point
    }
    
    func findVerticesInLineOfSight(_ points:[Vector2]) -> [(Vector2, Vector2)]{
        var edges: [(Vector2, Vector2)] = []
        for i in 0...points.count - 1 {
            for j in 0...points.count - 1 {
                let edge = (start:points[i], end:points[j])
                if inLineOfSight(polygon:polygon, start:edge.start, end:edge.end) {
                    edges.append(edge)
                }
            }
        }
        return edges
    }
    
    func inLineOfSight(polygon:PackedVector2Array, start:Vector2, end:Vector2) -> Bool
    {
        // Not in LOS if any of the ends is outside the polygon
        if !Geometry2D.isPointInPolygon(point: start, polygon: polygon) || !Geometry2D.isPointInPolygon(point:end, polygon: polygon) {
            return false
        }

        // Not in LOS if any edge is intersected by the start-end line segment
        for i in 0...points.count - 1 {
            if lineSegmentsCross(a: start, b: end, c: points[i], d: points[(i + 1) % (points.count - 1) ]){
                return false
            }
        }


        // Finally the middle point in the segment determines if in LOS or not
        //return polygon.contains(Vector2(x: (start.x + end.x)/2, y:(start.y + end.y)/2))
        
        return Geometry2D.isPointInPolygon(
            point:Vector2(x: (start.x + end.x)/2, y:(start.y + end.y)/2),
            polygon: polygon
        )
    }
    
    func lineSegmentsCross(a:Vector2, b:Vector2, c:Vector2, d:Vector2) -> Bool
    {
        let denominator = ((b.x - a.x) * (d.y - c.y)) - ((b.y - a.y) * (d.x - c.x))

        if (denominator == 0) {
            return false
        }

        let numerator1 = ((a.y - c.y) * (d.x - c.x)) - ((a.x - c.x) * (d.y - c.y));

        let numerator2 = ((a.y - c.y) * (b.x - a.x)) - ((a.x - c.x) * (b.y - a.y));

        if (numerator1 == 0 || numerator2 == 0) {
            return false
        }

        let r = numerator1 / denominator;
        let s = numerator2 / denominator;

        return (r > 0 && r < 1) && (s > 0 && s < 1)
    }
    
    /*private func findConcaveVertices() -> [Vector2]{
        var concavePoints:[Vector2] = []
        for i in 0...points.count - 1 {
            if IsVertexConcave(vertices: points, vertex: i) {
                concavePoints.append(points[i])
            }
        }
        return concavePoints
    }*/
    
    /*private func IsVertexConcave(vertices:[Vector2], vertex:Int) ->  Bool
    {
        let current  = vertices[vertex]
        let next     = vertices[(vertex + 1) % vertices.count]
        let previous = vertices[vertex == 0 ? vertices.count - 1 : vertex - 1]

        let left  = Vector2(x:current.x - previous.x, y:current.y - previous.y)
        let right = Vector2(x:next.x - current.x, y: next.y - current.y)

        let cross = (left.x * right.y) - (left.y * right.x)

        return cross < 0
    }*/
    
    public func contains(point:Vector2) -> Bool {
        Geometry2D.isPointInPolygon(point:point, polygon:polygon)
    }
}
