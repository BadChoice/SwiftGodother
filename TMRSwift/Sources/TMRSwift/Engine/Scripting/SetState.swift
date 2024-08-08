import Foundation

struct SetState : CompletableAction {
    
    let statable:ProvidesState
    let key:String
    let newState:String
    
    init(true key:String, _ statable:ProvidesState){
        self.statable = statable
        self.key = key
        self.newState = "true"
    }
    
    init(false key:String, _ statable:ProvidesState){
        self.statable = statable
        self.key = key
        self.newState = "false"
    }
    
    init(increment key:String, _ statable:ProvidesState){
        self.statable = statable
        self.key = key
        self.newState = "\(statable.getStateCount(key) + 1)"
    }
    
    func run(then: @escaping () -> Void) {
        statable.setState(key, value: newState)
        then()
    }
}


/**
 Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
 */
struct SetTrue : CompletableAction {
    init(_ variable:inout Bool){ variable = true }
    func run(then: @escaping () -> Void) { then() }
}

struct SetFalse : CompletableAction {
    init(_ variable:inout Bool){ variable = false }
    func run(then: @escaping () -> Void) { then() }
}

