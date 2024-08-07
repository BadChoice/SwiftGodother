import Foundation
import SwiftGodot

class Object : ProvidesState {
    
    var details:ObjectDetails!
    var json: String { "" }
    @objc dynamic var name:String { details.name }
    
    var position:Vector2 {
        //SketchApp.shared.screenSize
        (Vector2(stringLiteral: details.position! ) - Vector2(x:512, y:512)) * Game.shared.scale
    }
    
    var hotspot:Vector2 {
        //SketchApp.shared.screenSize
        (Vector2(stringLiteral: details.hotspot! ) - Vector2(x:512, y:512)) * Game.shared.scale
    }
    
    var facing:Facing { details.facing }
    
    required init(_ details:ObjectDetails? = nil){
        self.details = details
    }
    
    func isTouched(at: Vector2) -> Bool {
        guard let position = details.position else { return false }
        return at.near(Vector2(stringLiteral: position))
    }
    
    func shouldShowHotspotHint() -> Bool {
        true
    }
    
    //=======================================
    // MARK:- NODE
    //=======================================
    func getNode() -> Node2D? {
        nil
    }
    
    func remove(){
        
    }
    
    
    //=======================================
    // MARK:- VERBS
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
