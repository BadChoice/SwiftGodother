import Foundation

protocol ProvidesState {
    
}

extension ProvidesState {
    
    func setStateTrue(_ key:String){
        Game.shared.state.setTrue("\(self).\(key)")
    }
    
    func setState(_ key:String, value:String){
        Game.shared.state.setState("\(self).\(key)", value:value)
    }
    
    func isStateTrue(_ key:String) -> Bool{
        Game.shared.state.isTrue("\(self).\(key)")
    }
    
    func getStateCount(_ key:String) -> Int {
        Game.shared.state.getInt("\(self).\(key)")
    }
    
    @discardableResult
    func incrementState(_ key:String, by increment:Int = 1) -> Int {
        Game.shared.state.increment("\(self).\(key)", by:increment)
    }
    
    func setStateCount(_ key:String, value:Int){
        Game.shared.state.setInt("\(self).\(key)", value:value)
    }
    
    static func setStateTrue(_ key:String){
        Game.shared.state.setTrue("\(self).\(key)")
    }
    
    static func setState(_ key:String, value:String){
        Game.shared.state.setState("\(self).\(key)", value:value)
    }
    
    static func getState(_ key:String) -> String? {
        Game.shared.state.getState("\(self).\(key)")
    }
    
    static func isStateTrue(_ key:String) -> Bool{
        Game.shared.state.isTrue("\(self).\(key)")
    }
    
    static func getStateCount(_ key:String) -> Int {
        Game.shared.state.getInt("\(self).\(key)")
    }
    
    static func setStateCount(_ key:String, value:Int){
        Game.shared.state.setInt("\(self).\(key)", value:value)
    }
    
    @discardableResult
    static func incrementState(_ key:String, by increment:Int = 1) -> Int {
        Game.shared.state.increment("\(self).\(key)", by:increment)
    }
}
