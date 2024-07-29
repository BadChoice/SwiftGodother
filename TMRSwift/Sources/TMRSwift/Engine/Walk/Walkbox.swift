import SwiftGodot

class Walkbox {
    
    let frontScale:Float = 0.8
    let backScale:Float = 0.1
    let footsteps:Footsteps = .concrete
    
    let node = Line2D()
    var points:[Vector2]
    let polygon:Polygon
    
    init(points:String){
        let values = points.components(separatedBy: " ")
        self.points = values.chunked(into: 2).map {
            Vector2(stringLiteral: "\($0[0]) \($0[1])") - Vector2(x:712, y:512)
        }
        self.points.append(self.points.first!)
        polygon = Polygon(points: self.points)
        
        if Constants.debug {
            Self.drawPoints(node: node, points: self.points, color: .white)
        }
    }

    
    static func drawPoints(node:Line2D, points:[Vector2], color:Color, width:Double = 4){
        points.forEach {
            node.addPoint(position: $0)
        }
        node.addPoint(position: points.first!)
        node.defaultColor = color
        node.width = width
    }
    
    //https://www.david-gouveia.com/pathfinding-on-a-2d-polygonal-map
    func calculatePath(from:Vector2, to:Vector2) -> [Vector2]?{
        let from        = polygon.nearestInside(from)
        let to          = polygon.nearestInside(to)
        let graph       = polygon.buildGraph(from: from, to: to)
        return AStar(graph: graph, start: from, goal: to).findPath()
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
