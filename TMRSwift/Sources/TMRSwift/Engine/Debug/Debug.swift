import Foundation
import SwiftGodot

class Debug {
    
    static var roomType:Room.Type?
    
    static func setDebugGameState(){
        
        guard OS.isDebugBuild() else { return }
        
        roomType = Arcade.self
        
        inventory.pickup(Balloon())
        inventory.pickup(CarOil())
    }
}
