import SwiftGodot

typealias Point = Vector2
typealias Size  = Vector2

extension Vector2 {
    
    init(stringLiteral value: StringLiteralType) {
        let values = value.replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        let x = Float(Double(values[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        let y = Float(Double(values[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
        self.init(x:x, y:y)
    }
    
    init(value:Float) {
        self.init(x: value, y:value)
    }
    
        
    func near(_ point:Point, treshold:Float = 10) -> Bool {
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
