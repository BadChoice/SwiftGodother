import Foundation
import SwiftGodot

struct SketchApp {
    
    static var shared:SketchApp = SketchApp(screenSize: Vector2(x:1366, y:1024))
    
    let screenSize:Vector2
    
    func point(_ point:Vector2) -> Vector2 {
        Vector2(
            x:-Float(screenSize.x)/2 + point.x,
            y:Float(screenSize.y/2) - point.y
        )
    }
    
    func points(_ points:[Vector2]) -> [Vector2] {
        points.map { point($0) }
    }
}
