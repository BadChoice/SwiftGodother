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
        
        GD.print("[Room changer] Change room")
        
        Game.shared.scene.scanner.show(text: "", at: .zero)
        Game.shared.touchLocked = true
        
        let previousRoom = Game.shared.room
        Game.shared.scene.room = room.init()
        Game.shared.scene.addChild(node: Game.shared.room.node)
        Game.shared.room.node.modulate.alpha = 0
        Game.shared.room._ready()
        Game.shared.room.camera.enabled = false
        
        let blackNode = fullScreenBlack(previousRoom?.camera)
        
        guard previousRoom != nil else {
            return startRoom(room: Game.shared.room, roomsShareMusic:false)
        }
        
        let roomsShareMusic = previousRoom?.details.music == Game.shared.room.details.music
        
        Game.shared.scene.addChild(node: blackNode)
        GD.print("[Room changer] Black curtain")
        blackNode.run(.sequence([
            .fadeIn(withDuration: fadeTime),
            .wait(forDuration: stayTime)
        ])){

            previousRoom?.camera.enabled = false
            previousRoom?.camera.positionSmoothingEnabled = false
            Game.shared.room.putActor(at: actorPosition, facing: facing)
            Game.shared.room.camera.enabled = true
            removeRoom(room: previousRoom, roomsShareMusic:roomsShareMusic)
            startRoom(room: Game.shared.room, roomsShareMusic:roomsShareMusic)
            blackNode.run(.fadeOut(withDuration: fadeTime))
        }
    }
    
    func fullScreenBlack(_ camera:Camera2D?) -> ColorRect {
        let rect = ColorRect()
        
        if let camera {
            //GD.print(camera.getViewportRect(), camera.getScreenCenterPosition())
            rect.setSize(camera.getViewportRect().size * 2)
            rect.setPosition(camera.getViewportRect().size * -1 + camera.getScreenCenterPosition())
        }
        rect.color = curtainColor
        rect.zIndex = Constants.cursor_zIndex
        rect.modulate.alpha = 0
        return rect
        
    }
    
    func removeRoom(room:Room?, roomsShareMusic:Bool = false){
        guard let room = room else { return }
        room.stopMusic(onlyFx: roomsShareMusic)
        room.onExit()
        room.node.removeAllChildren()
        room.node.removeAllActions()
        room.objects.forEach { $0.remove() }
    }
    
    func startRoom(room:Room, roomsShareMusic:Bool = false){
        Game.shared.touchLocked = false
        room.node.modulate.alpha = 1
        room.playMusic(onlyFx: roomsShareMusic)
        room.onEnter()
    }
    
}
