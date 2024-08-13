import SwiftGodot

class LightObject : Object {
    
    override func isTouched(at: Vector2) -> Bool {
        false
    }
    
    override var showItsHotspotHint: Bool { false }
    
    
    override func getNode() -> Node2D? {
        nil
    }
    
}
