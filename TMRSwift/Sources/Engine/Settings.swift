import Foundation

class Settings : Codable {
    
    static var shared = Settings.load()
    
    var language:String = "en"
    var musicEnabled:Bool = true
    var hardMode:Bool = false
    
    
    func save(){
        UserStorage.make().save(settings: self)
        
    }
    
    static func load() -> Settings {
        UserStorage.make().loadSettings() ?? Settings()
    }
}
