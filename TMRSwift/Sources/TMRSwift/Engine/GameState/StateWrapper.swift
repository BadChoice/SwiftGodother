import Foundation

@propertyWrapper

struct StateWrapper {
    
    let key:String
    let statable:ProvidesState.Type
    
    init(_ key:String, object:ProvidesState.Type){
        self.key = key
        self.statable = object
    }
    
    var wrappedValue: Bool {
        get { statable.isStateTrue(key) }
        set { statable.setState(key, value: newValue ? "true" : "false") }
    }
}
