import Foundation
import SwiftGodot

class Object : NSObject, ProvidesState {
    
    var details:ObjectDetails!
    var json: String { "" }
    var scripts:ObjectScripts!
    
    @objc dynamic var name:String  { scripts.name   }
    @objc dynamic var zIndex:Int32 { scripts.zIndex }
    @objc dynamic var image:String { scripts.image  }
    
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
        scripts.shouldBeAddedToRoom()
    }
    
    /**
     * To override the default verb
     */
    var verbTexts:[Verbs : String]{
        [:]
    }
    
    /** The objects which can combine with (no ban icon appears) */
    @objc dynamic func combinesWith() -> [Object.Type] {
        scripts.combinesWith()
    }
    
    /** If it should show when showing the hotspot hints */
    @objc dynamic var showItsHotspotHint: Bool {
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
    @objc dynamic func onLookedAt(){
        scripts.onLookedAt()
    }
    
    @objc dynamic func onPhoned(){
        scripts.onLookedAt()
    }
    
    @objc dynamic func onUse(){
        scripts.onUse()
    }
    
    @objc dynamic func onMouthed()    {
        scripts.onMouthed()
    }
    
    @objc dynamic func onUseWith(_ object:Object, reversed:Bool){
        scripts.onUseWith(object, reversed: reversed)
    }
}

class ObjectScripts {
    weak var scriptedObject:Object!
    
    required init(object:Object) {
        scriptedObject = object
    }
    
    var name:String     { 
        scriptedObject.details.name
    }
    
    var zIndex:Int32    {
        Int32(scriptedObject.details.zPos)
    }
    
    var image:String  {
        scriptedObject.details.image!
    }
    
    var inventoryImage : String {
        safeClassName("\(scriptedObject.self)").components(separatedBy: ".").last!
    }
    
    //=======================================
    // MARK:- VERBS
    //=======================================
    /**
     @return Boo lif the object should be added to the room or not: Ex: Has already been picked up
     */
    func shouldBeAddedToRoom() ->Bool {
        if let inventoriable = scriptedObject as? Inventoriable {
            return !inventory.contains(inventoriable)
        }
        return true
    }
    
    func addToRoom(_ room:Room){
        guard shouldBeAddedToRoom() else { return }
        guard let node = scriptedObject.getNode() else { return }
        
        (node as? Node2D)?.zIndex = zIndex
        (node as? Control)?.zIndex = zIndex
        room.node.addChild(node: node)
    }
    
    
    /** The objects which can combine with (no ban icon appears) */
    func combinesWith() -> [Object.Type] {
        []
    }
    
    /** If it should show when showing the hotspot hints */
    var showItsHotspotHint: Bool {
        true
    }
    
    
    //=======================================
    // MARK:- VERBS
    //=======================================
    func onLookedAt(){
        ScriptSay(random:[
            "Looks interesting...",
            "Mmmm...",
            __("It is a") + " " + __(scriptedObject.name).lowercased()
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
        if let door = scriptedObject as? ChangesRoom {
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
            return object.onUseWith(scriptedObject, reversed:true)
        }
        ScriptSay(random: [
            "Mmmm... No",
            "I can't mix those",
            "I don't think this will work",
            //__("I can't use") + " " + __(self.name) + " " + __("with") + " " +  __(object.name),
            __("I can't use {object1} with {object2}")
                .replacingOccurrences(of: "{object1}", with:__(scriptedObject.name))
                .replacingOccurrences(of: "{object2}", with:__(object.name))
        ])
    }
}
