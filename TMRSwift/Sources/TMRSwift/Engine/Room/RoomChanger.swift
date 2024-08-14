import Foundation
import SwiftGodot

struct RoomChanger {
    
    let fadeTime:Double
    let curtainColor:Color
    let stayTime:Double
    
    init(fadeTime:Double = 0.4, color:Color = .black, stayTime:Double = 0.0) {
        self.fadeTime = fadeTime
        self.curtainColor = color
        self.stayTime = stayTime
    }
    
    func change(to room:Room.Type, actorPosition:Vector2? = nil, facing:Facing = .right){
       
        Game.shared.scene.scanner.show(text: "", at: .zero)
        Game.shared.touchLocked = true
        
        let previousRoom = Game.shared.room
        Game.shared.scene.room = room.init()
        Game.shared.scene.addChild(node: Game.shared.room.node)
        Game.shared.room.node.modulate.alpha = 0
        Game.shared.room._ready()
                        
        let blackNode = fullScreenBlack(previousRoom?.camera)
        
        guard previousRoom != nil else {
            return startRoom(room: Game.shared.room, roomsShareMusic:false)
        }
        
        let roomsShareMusic = previousRoom?.details.music == Game.shared.room.details.music
        
        Game.shared.scene.addChild(node: blackNode)
        blackNode.run(.sequence([
            .fadeIn(withDuration: fadeTime),
            .wait(forDuration: stayTime)
        ])){
            removeRoom(room: previousRoom, roomsShareMusic:roomsShareMusic)
            startRoom(room: Game.shared.room, roomsShareMusic:roomsShareMusic)
            blackNode.run(.fadeOut(withDuration: fadeTime))
        }
    }
    
    func fullScreenBlack(_ camera:Camera2D?) -> ColorRect {
        /*let black = SKShapeNode(rect: CGRect(x:0 - scene.size.width/2, y:0 - scene.size.height/2, width:scene.size.width, height:scene.size.height))
        black.fillColor = curtainColor
        black.lineWidth = 0
        black.alpha = 0
        black.zPosition = 6000
        return black*/
        let rect = ColorRect()
        
        GD.print("Change room")
        
        if let camera {
            rect.setSize(camera.getViewportRect().size)
            rect.setPosition(camera.getViewportRect().size * -0.5)
        }
        rect.color = curtainColor
        rect.zIndex = Constants.cursor_zIndex
        rect.modulate.alpha = 0
        return rect
        
    }
    
    func removeRoom(room:Room?, roomsShareMusic:Bool = false){
        guard let room = room else { return }
        //room.stopMusic(onlyFx: roomsShareMusic)
        room.onExit()
        room.node.removeAllChildren()
        room.node.removeAllActions()
        room.objects.forEach { $0.remove() }
    }
    
    func startRoom(room:Room, roomsShareMusic:Bool = false){
        Game.shared.touchLocked = false
        room.node.modulate.alpha = 1
        //room.playMusic(onlyFx: roomsShareMusic)
        room.onEnter()
    }
    
}
