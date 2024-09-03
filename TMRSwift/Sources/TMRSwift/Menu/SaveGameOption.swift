import Foundation

class SaveGameOption : MenuOption {
    
    init() {
        super.init(text: "Save Game")
    }
    
    override func perform() -> Bool {
        
        let game = SaveGame()
        UserStorage.make().upload(game, slot:1)
        
        debugPrint("[SaveGame] saved at slot 1")
        
        return true
    }
}


class LoadGameOption : MenuOption {
    init() {
        super.init(text: "Load Game")
    }
    
    override func perform() -> Bool {
        
        if let saveGame = UserStorage.make().get(slot: 1) {            
            Game.shared.load(saveGame: saveGame)
            saveGame.printToNGH()
        }
        
        debugPrint("[SaveGame] Loaded game at slot 1")
        
        return true
    }
}
