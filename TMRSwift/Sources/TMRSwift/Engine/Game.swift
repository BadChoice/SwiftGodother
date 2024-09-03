import Foundation
import SwiftGodot

class Game  {
    static let shared:Game = Game()
    
    var scene:MainScene!
    var room:Room! { scene.room }
    var actor:Actor! { room.actor }
    var talkEngine:TalkEngine!
    var currentYack:Yack?
    
    var state = GameState()
    var goingToDoor:ChangesRoom?
    var translations:Translations!
    
    var scale:Double = 1.0
    
    var touchLocked:Bool = false
    
    init(){
        try? translations = Translations.load(language: Settings.language)
    }
    
    func objectAtRoom<T:Object>(ofType:T.Type) -> T?{
        room.objects.first { $0 is T } as? T
    }
    
    func enter(room:Room.Type, actorPosition:Vector2, facing:Facing, fadeTime:Double = 0.4, color:Color = .black, stayTime:Double = 0){
        
        RoomChanger(fadeTime:fadeTime, color:color, stayTime:stayTime)
            .change(to: room, actorPosition: actorPosition, facing:facing)
        Hotspots.isBeingDisplayed = false
        goingToDoor = nil
    }
    
    func safePosition(_ position:Vector2, size:Vector2) -> Vector2 {
        
        var safePosition = position
        
        let minX = room.camera.getScreenCenterPosition().x - (room.camera.getViewportRect().size.x / 2)
        let maxX = room.camera.getScreenCenterPosition().x + (room.camera.getViewportRect().size.x / 2)
        let minY = room.camera.getScreenCenterPosition().y + (room.camera.getViewportRect().size.y / 2)
        let maxY = room.camera.getScreenCenterPosition().y - (room.camera.getViewportRect().size.y / 2)
        
        if position.x - (size.x/2) < minX {
            safePosition.x = minX + size.x/2
        }
        
        if position.x + (size.x/2) > maxX {
            safePosition.x = maxX - size.x/2
        }
        
        /*if position.y - (size.y/2) < minY {
            safePosition.y = minY + size.y/2
        }
        
        if position.y + (size.y/2) > maxY {
            safePosition.y = maxY - size.y/2
        }*/
        
        return safePosition/* - size * 0.5*/
    }
    
    //MARK: - SAVEGAME
    func load(saveGame:SaveGame){
        let room: AnyClass? = NSClassFromString(safeClassName(saveGame.roomType))
        state = saveGame.state
        inventory.load(objects:saveGame.inventoryObjects)
                
        enter(room: room as! Room.Type, actorPosition: saveGame.actorPosition, facing:.right)
    }
}


#if os(Linux)
// Code specific to Linux

#elseif os(macOS)
// Code specific to macOS

#elseif os(windows)

#endif


#if canImport(UIKit)
// Code specific to platforms where UIKit is available


#endif
