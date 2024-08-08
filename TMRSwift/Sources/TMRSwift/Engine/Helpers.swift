import Foundation

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

func roomObject<T:Object>(_ ofType:T.Type) -> T?{
    Game.shared.objectAtRoom(ofType: ofType)
}
