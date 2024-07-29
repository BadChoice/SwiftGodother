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
            Vector2(stringLiteral: "\($0[0]) \($0[1])") - Vector2(x:712, y:512)
        }
        
        Self.drawPoints(node: node, points: self.points, color: .white)
    }
    
    var polygon: PackedVector2Array {
        let polygon = PackedVector2Array()
        points.forEach { polygon.append($0)}
        return polygon
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
        let from        = nearestInside(from)
        let to          = nearestInside(to)
        let graph       = buildGraph(from:from, to:to)
        return AStar(graph: graph, start: from, goal: to).findPath()
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
    
    private func buildGraph(from:Vector2, to:Vector2) -> AStar.Graph {
        //var concavePoints = findConcaveVertices()
        var concavePoints = points
        concavePoints.append(from)
        concavePoints.append(to)
        let edges         = findVerticesInLineOfSight(concavePoints)
        return AStar.Graph(points:points, conections: edges)
    }
    
    
    private func findConcaveVertices() -> [Vector2]{
        var concavePoints:[Vector2] = []
        for i in 0...points.count - 1 {
            if IsVertexConcave(vertices: points, vertex: i) {
                concavePoints.append(points[i])
            }
        }
        return concavePoints
    }
    
    private func IsVertexConcave(vertices:[Vector2], vertex:Int) ->  Bool
    {
        let current  = vertices[vertex]
        let next     = vertices[(vertex + 1) % vertices.count]
        let previous = vertices[vertex == 0 ? vertices.count - 1 : vertex - 1]

        let left  = Vector2(x:current.x - previous.x, y:current.y - previous.y)
        let right = Vector2(x:next.x - current.x, y: next.y - current.y)

        let cross = (left.x * right.y) - (left.y * right.x)

        return cross < 0
    }
    
    private func findVerticesInLineOfSight(_ points:[Vector2]) -> [(Vector2, Vector2)]{
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
    
    
    private func lineSegmentsCross(a:Vector2, b:Vector2, c:Vector2, d:Vector2) -> Bool
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
    
    private func inLineOfSight(polygon:PackedVector2Array, start:Vector2, end:Vector2) -> Bool
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
