import Foundation

class Game  {
    static let shared:Game = Game()
    
    //var scene:Scene!
    var room:Room!
    var player:Player!
    
    var state = GameState()
    
    var scale:Double = 1.0
    
    var touchLocked:Bool = false
}


/** Tihs will handle the translations*/
func __(_ key:String) -> String {
    key
}

func safeClassName(_ name:String) -> String {
    let module          = String(reflecting: Game.self).components(separatedBy: ".").first!
    return module + "." + name.components(separatedBy: ".").last!.components(separatedBy: ":").first!
}


#if os(Linux)
// Code specific to Linux

#elseif os(macOS)
// Code specific to macOS

#elseif os(windows)

#endif


#if canImport(UIKit)
// Code specific to platforms where UIKit is available


#endif
