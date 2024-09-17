import Foundation
import SwiftGodot

class Object : ProvidesState {
    
    var details:ObjectDetails!
    var json: String { "" }
    var scripts:ObjectScripts!
    
    var name:String  { scripts.name   }
    var zIndex:Int32 { scripts.zIndex }
    var image:String { scripts.image  }
    
    var position:Vector2 {
        guard let detailsPosition = details.position else { return .zero}
        return SketchApp.shared.point(Vector2(stringLiteral: detailsPosition))
    }
    
    var hotspot:Vector2 {
        SketchApp.shared.point(Vector2(stringLiteral: details.hotspot!))
    }
    
    func centerPoint() -> Vector2 {
        position
    }
    
    var facing:Facing { details.facing }
    
    required init(_ details:ObjectDetails? = nil){
        loadScripts()
         
        if let details {
            self.details = details
        } else {
            let json = "res://assets/rooms/" + json + ".json"
            self.details = RoomDetails.loadCached(path: json).detailsFor(self)
            if details == nil {
                GD.printErr("[Object] No details found for \(self)")
                //abort()
            }
        }
    }
    
    func loadScripts(){
        scripts = (NSClassFromString(safeClassName("\(Self.self)Scripts")) as? ObjectScripts.Type)?.init(object: self) ?? ObjectScripts(object: self)
    }
    
    func isTouched(at: Vector2) -> Bool {
        guard let position = details.position else { return false }
        return at.near(Vector2(stringLiteral: position))
    }
    
    /** Each object can define with what it does combine to speed up puzzle resolution */
    func canBeUsedWith(_ object:Object) -> Bool {
        guard Features.useCanBeUsedWith else { return true }
        return combinesWith().contains {
            $0 == type(of: object)
        }
    
    }
    
    /**
     Finds the object at the room and returns the instance
     */
    static func findAtRoom() -> Self {
        Game.shared.objectAtRoom(ofType: self)!
    }
    
    //=======================================
    // MARK:- OVERRIDABLE
    //=======================================
    /**
     @return Boo lif the object should be added to the room or not: Ex: Has already been picked up
     */
    func shouldBeAddedToRoom() ->Bool {
        scripts.shouldBeAddedToRoom()
    }
    
    /**
     * To override the default verb
     */
    var verbTexts:[Verbs : String]{
        [:]
    }
    
    /** The objects which can combine with (no ban icon appears) */
    func combinesWith() -> [Object.Type] {
        scripts.combinesWith()
    }
    
    /** If it should show when showing the hotspot hints */
    var showItsHotspotHint: Bool {
        scripts.showItsHotspotHint
    }
    
    
    //=======================================
    // MARK:- NODE
    //=======================================
    func addToRoom(_ room:Room){
        scripts.addToRoom(room)
    }
    
    func getNode() -> Node? {
        nil
    }
    
    func remove(){
        
    }
    
    //=======================================
    // MARK:- VERBS
    //=======================================
    func onLookedAt(){
        scripts.onLookedAt()
    }
    
    func onPhoned(){
        scripts.onLookedAt()
    }
    
    func onUse(){
        scripts.onUse()
    }
    
    func onMouthed()    {
        scripts.onMouthed()
    }
    
    func onUseWith(_ object:Object, reversed:Bool){
        scripts.onUseWith(object, reversed: reversed)
    }
}

