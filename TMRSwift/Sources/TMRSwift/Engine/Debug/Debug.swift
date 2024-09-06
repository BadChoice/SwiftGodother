import Foundation

class Debug {
    
    static var roomType:Room.Type?
    
    static func setDebugGameState(){
        
        guard Constants.debug else { return }
        
        //roomType = Arcade.self
        
        //inventory.pickup(Balloon())
        //inventory.pickup(CarOil())
    }
}
