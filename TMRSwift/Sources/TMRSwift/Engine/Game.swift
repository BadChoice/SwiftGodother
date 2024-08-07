import Foundation

class Game  {
    static let shared:Game = Game()
    
    var scene:MainScene!
    var room:Room!
    var player:Player!
    var talkEngine:TalkEngine!
    
    var state = GameState()
    
    var scale:Double = 1.0
    
    var touchLocked:Bool = false
}


var inventory: Inventory {
    Game.shared.scene.inventoryUI.inventory
}

/** Tihs will handle the translations*/
func __(_ key:String) -> String {
    key
}

func safeClassName(_ name:String) -> String {
    let module          = String(reflecting: Game.self).components(separatedBy: ".").first!
    return module + "." + name.components(separatedBy: ".").last!.components(separatedBy: ":").first!
}

func ScriptSay(_ text:String, expression:Expression? = nil, armsExpression:ArmsExpression? = nil){
    Script{
        Say(text, expression: expression, armsExpression:armsExpression)
    }
}

func ScriptSay(random:[String]){
    Script{
        Say(random:random)
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
