import Foundation

class GameState : Codable {
    
    var state:[String:[String:String]] = [:]
    
    func setState(_ keyPath:String, value:String){
        let components = Array(keyPath.components(separatedBy: ".").reversed())
        let primary     = components[1]
        let secondary   = components[0]
        state[primary, default: [:]][secondary] = value
    }
    
    func getState(_ keyPath:String) -> String?{
        let components = Array(keyPath.components(separatedBy: ".").reversed())
        let primary     = components[1]
        let secondary   = components[0]
        return state[primary]?[secondary]
    }
    
    func setTrue(_ keyPath:String){
        setState(keyPath, value:"true")
    }
    
    func isTrue(_ keyPath:String) -> Bool{
        getState(keyPath) == "true"
    }
    
    func getInt(_ keyPath:String) -> Int {
        guard let value = getState(keyPath) else { return 0 }
        return Int(value) ?? 0
    }
    
    func setInt(_ keyPath:String, value:Int){
        setState(keyPath, value: "\(value)")
    }
    
    @discardableResult
    func increment(_ keyPath:String, by increment:Int = 1) -> Int{
        let newValue = getInt(keyPath) + increment
        setInt(keyPath, value: newValue)
        return newValue
    }
    
    func clearAll(){
        state = [:]
    }
}
