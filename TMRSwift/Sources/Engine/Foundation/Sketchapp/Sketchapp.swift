import Foundation
import SwiftGodot

struct SketchApp {
    
    //static let shared:SketchApp = SketchApp(screenSize: Vector2(x:1366, y:1024))
    static let shared:SketchApp = SketchApp(screenSize: Vector2(x:1366, y:1024))
    
    let screenSize:Vector2
    
    func point(_ point:Vector2) -> Vector2 {
        (Vector2(x: point.x, y:point.y) * Game.shared.scale) - (SketchApp.shared.screenSize / 2 * Game.shared.scale)
    }
    
    func points(_ points:[Vector2]) -> [Vector2] {
        points.map { point($0) }
    }
}
