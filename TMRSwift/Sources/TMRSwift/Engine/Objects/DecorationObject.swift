import SwiftGodot

class DecorationObject : SpriteObject {
    
    required init(_ details: ObjectDetails? = nil) {
        super.init(details)
    }
    
    override func isTouched(at: Vector2) -> Bool {
        false
    }
    
    override dynamic var showItsHotspotHint: Bool {
        false
    }
}
