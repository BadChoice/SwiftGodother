import SwiftGodot

class SaveGameOption : Menu.Option {
    
    var squares:[SaveGameNode]!
    
    lazy var savedGames = { UserStorage.make().getSavedGames() }()
    
    init() {
        super.init(text: "Save Game")
    }
    
    override func perform(_ node:Node) -> Bool {
        
        squares = SaveGameGrid.draw(size: (node as! ColorRect).getRect().size) {
            let saveGameNode = SaveGameNode().setup(saveGame: saveGameAt(slot: $0))
            //if $0 == 0 { node.modulate.alpha = 0.3 }    //The autosave
            node.addChild(node: saveGameNode.node)
            return saveGameNode
        }
        
        return false
    }
    
    override func touched(at point:Vector2) -> Bool {
        let selectedSquare = squares.first { $0.node.getRect().hasPoint(point) }
        if selectedSquare == nil { return false }
        guard let slot = squares.map { $0.node }.firstIndex(of: selectedSquare!.node) else { return false }
        if slot == 0 { return true }
        
        UserStorage.make().upload(SaveGame(), slot: slot)
        debugPrint("[SaveGame] saved at slot \(slot)")
        
        return true
    }
    
    func saveGameAt(slot:Int) -> SaveGame? {
        savedGames.first { $0.1 == slot }?.0
    }
}


class LoadGameOption : Menu.Option {
    init() {
        super.init(text: "Load Game")
    }
    
    override func perform(_ node:Node) -> Bool {
        
        if let saveGame = UserStorage.make().get(slot: 1) {            
            Game.shared.load(saveGame: saveGame)
            saveGame.printToNGH()
        }
        
        debugPrint("[SaveGame] Loaded game at slot 1")
        
        return true
    }
}
