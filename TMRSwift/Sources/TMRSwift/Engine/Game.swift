import Foundation

class Game  {
    static let shared:Game = Game()
    
    //var scene:Scene!
    var room:Room!
    var player:Player!
    
    var scale:Double = 1.0
}


/** Tihs will handle the translations*/
func __(_ key:String) -> String {
    key
}
