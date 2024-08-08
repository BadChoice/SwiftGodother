import SwiftGodot

class Game  {
    static let shared:Game = Game()
    
    var scene:MainScene!
    var room:Room!
    var actor:Actor!
    var talkEngine:TalkEngine!
    
    var state = GameState()
    
    var scale:Double = 1.0
    
    var touchLocked:Bool = false
    
    func objectAtRoom<T:Object>(ofType:T.Type) -> T?{
        room.objects.first { $0 is T } as? T
    }
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
