import SwiftGodot

class Object {
    
    var details:ObjectDetails!
    
    init(_ details:ObjectDetails){
        self.details = details
    }
    
    func isTouched(at: Vector2) -> Bool {
        guard let position = details.position else { return false }
        return at.near(Vector2(stringLiteral: position))
    }
    
    func shouldShowHotspotHint() -> Bool {
        true
    }
}
