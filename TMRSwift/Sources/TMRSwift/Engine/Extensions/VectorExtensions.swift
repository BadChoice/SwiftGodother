import SwiftGodot

extension Vector2 {
    
    func near(_ point:Vector2, treshold:Float = 10) -> Bool {
        x.near(point.x, treshold: treshold) &&
        y.near(point.y, treshold: treshold)
    }
    
    func adding(x:Float = 0, y:Float = 0) -> Vector2 {
        Vector2(x: self.x + Float(x), y: self.y + Float(y))
    }
}

extension Float {
    
    func near(_ point:Float, treshold:Float = 5) -> Bool {
        self > point - treshold && self < point + treshold
    }
}
