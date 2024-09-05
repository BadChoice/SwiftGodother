import Foundation
import SwiftGodot

var inventory: Inventory {
    Game.shared.scene.inventoryUI.inventory
}

/** Tihs will handle the translations*/
func __(_ key:String) -> String {
    Game.shared.translations?.translated(key) ?? key
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

func ScriptWalkToAndSay(_ object:Object, _ text:String, expression:Expression? = nil, armsExpression:ArmsExpression? = nil){
    Script{
        WalkToAndSay(object, text, expression: expression, armsExpression:armsExpression)
    }
}

func roomObject<T:Object>(_ ofType:T.Type) -> T?{
    Game.shared.objectAtRoom(ofType: ofType)
}

func texture(_ name:String) -> Texture2D? {
    Game.shared.room.atlas.textureNamed(name: name)
}
