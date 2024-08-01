import Foundation
import SwiftGodot

class Object {
    
    var details:ObjectDetails!
    
    var name:String { details.name }
    
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
    
    
    // MARK:- Objects
    //=======================================
    // VERBS
    //=======================================
    @objc dynamic func onLookedAt(){
        GD.print("on looked at \(name)")
    }
    
    @objc dynamic func onPhoned() {
        GD.print("on phoned at \(name)")
    }
    
    @objc dynamic func onUse()    {
        GD.print("on use at \(name)")
    }
    
    @objc dynamic func onMouthed()    {
        GD.print("on mouthed at \(name)")
    }
}
