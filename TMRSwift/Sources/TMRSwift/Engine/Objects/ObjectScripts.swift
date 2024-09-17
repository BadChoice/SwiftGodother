import SwiftGodot

class ObjectScripts : Animable, Talks {
    weak var scriptedObject:Object!
    
    required init(object:Object) {
        scriptedObject = object
    }
    
    var name:String { scriptedObject.details.name }
    var zIndex:Int32 { Int32(scriptedObject.details.zPos) }
    var image:String { scriptedObject.details.image! }
    var inventoryImage : String {
        safeClassName("\(scriptedObject!.self)").components(separatedBy: ".").last!
    }
    var inInventory : Bool { (scriptedObject as? Inventoriable)?.inInventory ?? false }
    
    //=======================================
    // MARK:- TALK
    //=======================================
    var voiceType: VoiceType { .male }
    var talkColor: Color { (scriptedObject as? Talks)?.talkColor ?? "#EDEB67" }
    var talkPosition: Vector2 {
        Vector2(x:scriptedObject.position.x, y: scriptedObject.position.y + 100 * Float(Game.shared.scale))
    }
    
    func setExpression(_ expression:Expression?) { }
    func setArmsExpression(_ expression:ArmsExpression?) { }
    
    //=======================================
    // MARK:- Lifecycle
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
    
    /** To determine if it is touched **/
    //TODO: Remove and use is decoration
    func isTouched(point: Point) -> Bool {
        scriptedObject.isTouched(at: point)
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
    
    //=======================================
    // DOORS
    //=======================================
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        then(true)
    }
    
    //=======================================
    // MARK:- ANIMABLE
    //=======================================
    func animate(_ animation:String?){
        (self as? NpcScripts)?.animateNpc(animation)
    }
}
