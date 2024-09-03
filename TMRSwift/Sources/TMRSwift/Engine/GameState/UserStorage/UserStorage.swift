import Foundation
import SwiftGodot

class UserStorage {
        
    static var STORAGE_KEY = "save-game"
    
    static func upload(_ saveGame:SaveGame, slot:Int){
        guard let json = saveGame.toJson() else {
            return
        }
        save(json, forKey:"\(Self.STORAGE_KEY)-\(slot)")
    }
    
    static func getSavedGames() -> [(SaveGame, Int)] {
        []
        /*getKeys().compactMap {
            let slot = $0.replacingOccurrences(of: STORAGE_KEY + "-", with: "")
            guard let saveGame = get(slot: Int(slot)!) else { return nil }
            return (saveGame, Int(slot)!)
        }*/
    }
    
    static func getLastSavedGame() -> SaveGame?{
        self.getSavedGames().sorted(by: { $0.0.date > $1.0.date} ).first?.0
    }
    
    static func get(slot:Int) -> SaveGame? {
        guard let json = get(key:"\(Self.STORAGE_KEY)-\(slot)") else {
            return nil
        }
        do{
            let game = try SaveGame.load(json: json)
            return game
        }catch{
            print("[SAVEGAME] Can't load saved game: \(error)")
            return nil
        }
        
    }
    
    /*static func getKeys() -> [String] {
        keys(matching:STORAGE_KEY)
    }*/
    
    static func remove(slot:Int){
        delete(key: "\(Self.STORAGE_KEY)-\(slot)")
    }
    
    
    //MARK - Storage wrapper
    static private func save(_ value:String, forKey key:String){
        let file = FileAccess.open(path: "user://\(key).save", flags: .writeRead)
        file?.storeString(value)
        file?.close()
    }
    
    static private func delete(key:String){
        DirAccess().remove(path: "user://\(key).save")
    }
    
    static private func get(key:String) -> String?{
        FileAccess.getFileAsString(path: "user://\(key).save")
    }
    
    /*static private func keys(matching:String) -> [String] {
        
    }*/
    
}
