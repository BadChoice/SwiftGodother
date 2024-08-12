import SwiftGodot

class Game  {
    static let shared:Game = Game()
    
    var scene:MainScene!
    var room:Room!
    var actor:Actor!
    var talkEngine:TalkEngine!
    
    var state = GameState()
    
    var scale:Double = 1.0
    
    var touchLocked:Bool = false
    
    func objectAtRoom<T:Object>(ofType:T.Type) -> T?{
        room.objects.first { $0 is T } as? T
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
