import Foundation
import SwiftGodot

struct ObjectDetails : Codable {
    let objectClass:String
    let name:String
    let hotspot:String?
    let position:String?
    let zPos:Int
    let image:String?
    let size:String?
    let polygon:String?
    let facing:Facing
    let reach:Reach?
    
    let door:DoorDetails?
    let light:LightDetails?
}

struct DoorDetails : Codable {
    let nextRoom: String
    let nextRoomEntryPoint: String
    let nextRoomArrowDirection: ArrowDirection
    let nextRoomFacing:Facing?
    let changeRoomSound: String?
}

struct LightDetails : Codable {
    let color:String
    let blinkType:String
    let radius:Float
}

struct WalkboxDetails : Codable {
    
}

struct RoomDetails : Codable {
    let name:String
    let background:String
    let foreground:String?
    let music:String?
    let ambienceSound:String?
    let atlasName:String
    
    let objects:[ObjectDetails]
    let doors:[ObjectDetails]
    let lights:[ObjectDetails]?
    let walkBoxes:[String]
    let frontZScale:Float
    let backZScale:Float
    
    
    static func loadCached(path: String) -> RoomDetails {
        Cache.shared.cache(key: "roomDetails-\(path)", {
            RoomDetails.load(path: path)!
        })
    }
    
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
    
    func setup() -> [Object] {
        setupDoors() + setupObjects() + setupLights()
    }
    
    private func setupDoors() -> [Object] {
        doors.map {
            let objectType = NSClassFromString(safeClassName($0.objectClass)) as! Object.Type
            return objectType.init($0)
        }
    }
    
    private func setupObjects() -> [Object] {
        objects.compactMap {
            guard let objectType = NSClassFromString(safeClassName($0.objectClass)) as? Object.Type else { return nil }
            return objectType.init($0)
        }
    }
    
    private func setupLights() -> [Object] {
        lights?.compactMap {
            guard let objectType = NSClassFromString(safeClassName($0.objectClass)) as? Object.Type else { return nil }
            return objectType.init($0)
        } ?? []
    }
    
    func detailsFor(_ object:Object) -> ObjectDetails?{
        let className = String(String("\(object)".split(separator: ".").last!).split(separator: ":").first!)
        return (objects).first { $0.objectClass == className }
    }
}
