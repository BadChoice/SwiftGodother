import SwiftGodot
import Foundation

struct SaveGameGrid {
    static func draw(size:Vector2, block:(_ slot:Int) -> SaveGameNode) -> [SaveGameNode] {
        
        var position = size * 0.5 + (Vector2(x: -500, y:-300) * Game.shared.scale)
        
        return (0...8).map {
            let node = block(Int($0))
            node.node.setPosition(position - node.node.getRect().size * 0.2)
            
            if ($0 + 1) % 3 == 0 {
                position.y += 240 * Float(Game.shared.scale)
                position.x = (size.x * 0.5) - (500 * Float(Game.shared.scale))
            } else {
                position.x += 400 * Float(Game.shared.scale)
            }
            return node
        }
    }
}


class SaveGameNode {
    
    let node:ColorRect = ColorRect()
    let rectSize = Vector2(x: 340, y: 175)
    
    func setup(saveGame:SaveGame?) -> Self {
                       
        setupBackground()
        
        guard let saveGame else {
            return self
        }
        
        let label = Label()
        label.labelSettings = Label.settings()

        label.text           = saveGame.date.display
        //sectionLabel.fontSize       = 30
        //sectionLabel.numberOfLines  = 2
        label.zIndex      = 3
        label.setPosition(Vector2(x:0, y:140) * Game.shared.scale)
        label.horizontalAlignment = .center
                
        if let bg = background(saveGame: saveGame){
            node.addChild(node: bg)
            bg.position = bg.getRect().size * 0.5
            bg.zIndex = 1
        } else {
            node.modulate.alpha = 0.3
        }
        
        node.addChild(node: label)
        
        return self
    }
    
    
    func setupBackground() {
        //setPosition(Vector2(x: -size.x / 2, y: size.y / 2) * Game.shared.scale)
        node.setSize(rectSize * Game.shared.scale)
        
        //square.lineWidth       = 2
        //square.strokeColor     = .white
        //node.modulate.alpha      = 0.3
    }
    
    func background(saveGame:SaveGame) -> Sprite2D? {
        guard let roomClass = NSClassFromString(safeClassName(saveGame.roomType)) as? Room.Type else { return nil }
        
        let room = roomClass.init()
        room.loadDetails()
                
        return Sprite2D(path: "res://assets/ui/SaveGameThumbnails/\(room.details.background)-thumbnail.png")
    }
}
