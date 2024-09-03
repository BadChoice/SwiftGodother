import Foundation
import SwiftGodot

class SaveGame : Codable {
    
    let date:Date
    let state:GameState
    let roomType:String
    let actorPositionX:Float
    let actorPositionY:Float
    let inventoryObjects:[String]
    
   init(){
        state            = Game.shared.state
        roomType         = "\(Game.shared.room!.self)"
        actorPositionX    = Game.shared.room!.actor.node.position.x
        actorPositionY    = Game.shared.room!.actor.node.position.y
        inventoryObjects = inventory.objects.map { "\($0.object)" }
        date             = Date()
    }
    
    var room : String {
        __(roomType.components(separatedBy: ".").last ?? "")
    }
    
    var title : String {
        date.display + "\n" + room
    }
    
    var actorPosition:Vector2 {
        Vector2(x: actorPositionX, y:actorPositionY)
    }
        
    static func load(json:String) throws -> SaveGame {
        guard let data = json.data(using: .utf8) else {
            return SaveGame()
        }
        return try JSONDecoder().decode(SaveGame.self, from: data)
    }
        
    func toJson() -> String?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    static func sampleSaveGame() throws -> SaveGame {
        let json = """
        {
          "date": 589331953.61679399,
          "inventoryObjects" : [
            "NowhereToGo.Phone",
            "NowhereToGo.HackersBook"
          ],
          "roomType" : "NowhereToGo.Apartment",
          "state" : {
            "state" : {
              "Doormat" : {
                "pushed" : "true"
              }
            }
          },
          "actorPosition" : [
            122.97349548339844,
            -318.00732421875
          ]
        }
        """
        return try load(json: json)
    }
    
    func printToNGH(){
        inventoryObjects.forEach {
            print("item:\(safeClassName($0).components(separatedBy: ".").last!)=true")
        }
        state.state.forEach { (key: String, value: [String : String]) in
            value.forEach { (key2: String, value2: String) in
                print("\(key)-\(key2)=\(value2)")
            }
        }
    }
    
    func ngh() -> [String:Bool] {
        var ngh:[String:Bool] = [:]
        
        inventoryObjects.forEach {
            ngh["item:\(safeClassName($0).components(separatedBy: ".").last!)"] = true
        }
        state.state.forEach { (key: String, value: [String : String]) in
            value.forEach { (key2: String, value2: String) in
                ngh["\(key)-\(key2)"] = value2 == "true"
            }
        }
        return ngh
    }
}

