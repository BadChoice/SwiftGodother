import Foundation

class Game  {
    static let shared:Game = Game()
    
    //var scene:Scene!
    var room:Room!
    var player:Player!
    
    var state = GameState()
    
    var scale:Double = 1.0
}


/** Tihs will handle the translations*/
func __(_ key:String) -> String {
    key
}

func safeClassName(_ name:String) -> String {
    let module          = String(reflecting: Game.self).components(separatedBy: ".").first!
    return module + "." + name.components(separatedBy: ".").last!.components(separatedBy: ":").first!
}
