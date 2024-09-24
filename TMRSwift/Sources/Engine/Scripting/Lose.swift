import Foundation

class Lose : CompletableAction {
    
    let object:Inventoriable
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    convenience init(_ object:ObjectScripts, settingTrue state:inout Bool){
        self.init(object.scriptedObject as! Inventoriable, settingTrue: &state)
    }
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    convenience init(_ object:ObjectScripts, settingFalse state:inout Bool){
        self.init(object.scriptedObject as! Inventoriable, settingFalse: &state)
    }
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    init(_ object:Inventoriable, settingTrue state:inout Bool){
        self.object = object
        state = true
    }
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    init(_ object:Inventoriable, settingFalse state:inout Bool){
        self.object = object
        state = false
    }
    
    init(_ object:Inventoriable, notChanginState dumb:Bool){
        self.object = object
    }
    
    func run(then: @escaping () -> Void) {
        inventory.lose(object)
        then()
    }
}
