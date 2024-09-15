import Foundation
import SwiftGodot

class ObjectVerbActionsHandler {
    weak var object:Object!
    
    required init(object:Object) {
        self.object = object
    }
    
    func onLookedAt(){
        ScriptSay(random:[
            "Looks interesting...",
            "Mmmm...",
            __("It is a") + " " + __(object.name).lowercased()
            ]
        )
    }
    
    func onPhoned(){
        ScriptSay(random: [
            "No...",
            "This won't work",
            "Bad idea...",
            "I can't hack that with my phone.",
        ])
    }
    
    func onUse()    {
        if let door = object as? ChangesRoom {
            return door.goThrough()
        }
        
        ScriptSay(random: [
            "I don't think it is a good idea",
            "This leads to anything",
            "This won't work",
            "There needs to be something else"
        ])
    }
    
    func onMouthed(){
        ScriptSay(random: [
            "I don't want to lick this",
            "Aaarhg no",
            "I don't want to taste it",
            "I won't put my lips there",
            "It won't make any difference",
            "Don't be ridiculous, I won't talk to THAT!"
        ])
    }
    
    func onUseWith(_ object:Object, reversed:Bool){
        if !reversed {
            return object.onUseWith(self.object, reversed:true)
        }
        ScriptSay(random: [
            "Mmmm... No",
            "I can't mix those",
            "I don't think this will work",
            //__("I can't use") + " " + __(self.name) + " " + __("with") + " " +  __(object.name),
            __("I can't use {object1} with {object2}")
                .replacingOccurrences(of: "{object1}", with:__(self.object.name))
                .replacingOccurrences(of: "{object2}", with:__(object.name))
        ])
        
    }
}

class Object : NSObject, ProvidesState {
    
    var details:ObjectDetails!
    var json: String { "" }
    var verbActionsHandler:ObjectVerbActionsHandler!
    
    @objc dynamic var name:String { details.name }
    @objc dynamic var zIndex:Int32 { Int32(details.zPos) }
    
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
        super.init()
        
        verbActionsHandler = (NSClassFromString(safeClassName("\(Self.self)Handler")) as? ObjectVerbActionsHandler.Type)?.init(object: self) ?? ObjectVerbActionsHandler(object: self)
         
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
    
    
    func isTouched(at: Vector2) -> Bool {
        guard let position = details.position else { return false }
        return at.near(Vector2(stringLiteral: position))
    }
    
    /** Each object can define with what it does combine to speed up puzzle resolution */
    func canBeUsedWith(_ object:Object) -> Bool {
        guard Features.useCanBeUsedWith else { return true }
        return combinesWith().contains { object.isKind(of: $0) }
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
    @objc dynamic func shouldBeAddedToRoom() ->Bool {
        if let inventoriable = self as? Inventoriable {
            return !inventory.contains(inventoriable)
        }
        return true
    }
    
    /**
     * To override the default verb
     */
    var verbTexts:[Verbs : String]{
        [:]
    }
    
    /** The objects which can combine with (no ban icon appears) */
    @objc dynamic func combinesWith() -> [Object.Type] {
        []
    }
    
    /** If it should show when showing the hotspot hints */
    @objc dynamic var showItsHotspotHint: Bool {
        true
    }
    
    
    //=======================================
    // MARK:- NODE
    //=======================================
    @objc dynamic func addToRoom(_ room:Room){
        guard shouldBeAddedToRoom() else { return }
        guard let node = getNode() else { return }
        
        (node as? Node2D)?.zIndex = zIndex
        (node as? Control)?.zIndex = zIndex
        room.node.addChild(node: node)
    }
    
    func getNode() -> Node? {
        nil
    }
    
    func remove(){
        
    }
    
    
    //=======================================
    // MARK:- VERBS
    //=======================================
    @objc dynamic func onLookedAt(){
        verbActionsHandler.onLookedAt()
    }
    
    @objc dynamic func onPhoned() {
        verbActionsHandler.onLookedAt()

    }
    
    @objc dynamic func onUse()    {
        verbActionsHandler.onUse()
    }
    
    @objc dynamic func onMouthed()    {
        verbActionsHandler.onMouthed()
    }
    
    @objc dynamic func onUseWith(_ object:Object, reversed:Bool){
        verbActionsHandler.onUseWith(object, reversed: reversed)
    }
}
