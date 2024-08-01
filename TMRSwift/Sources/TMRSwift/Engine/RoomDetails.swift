import Foundation
import SwiftGodot

struct ObjectDetails : Codable {
    let name:String
    let hostspot:String?
    let position:String?
    let zPos:Int
    let image:String?
    let size:String?
    let polygon:String?
    let facing:Facing
    let reach:Reach
}

struct DoorDetails : Codable {
    
}

struct LightDetails : Codable {
    
    
}

struct WalkboxDetails : Codable {
    
}

struct RoomDetails : Codable {
    let name:String
    let background:String
    let foreground:String?
    let music:String?
    let ambienceSound:String?
    let atlasName:String?
    
    let objects:[ObjectDetails]
    let doors:[DoorDetails]
    let lights:[LightDetails]
    let walkBoxes:[String]
    
    static func load(path: String) -> RoomDetails? {
        let json = FileAccess.getFileAsString(path: path)
            
        do {
            let details = try JSONDecoder().decode(RoomDetails.self, from: json.data(using: .utf8)!)
            //GD.print(details)
            GD.print("Room json loaded: \(details.objects.count)")
            return details
        }catch{
            GD.printErr("Loading room json: \(error)")
            return nil
        }
    }
}
