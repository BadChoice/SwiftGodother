import SwiftGodot
import Foundation

@Godot
class Room : Node2D {
        
    var player:Player!
    var background:Sprite2D!
    var foreground:Sprite2D!
    var bgMusic:AudioStreamPlayer!
    
    var details:RoomDetails!
    
    var walkbox:Walkbox!
    var objects:[Object] = []
    var camera = Camera2D()
    
    override func _ready() {
        addBackgroundAndForeground()
        addBgMusic()
        addPlayer()
        setupCamera()
        addObjects()
        addWalkPath()
    }
    
    private func addPlayer(){
        player = Player()
        player.zIndex = 1
        self.addChild(node: player)
    }
    
    private func setupCamera(){
        camera.positionSmoothingEnabled = true
        camera.positionSmoothingSpeed = 0.8
        
        camera.limitSmoothed = true
        camera.limitBottom = 512
        camera.limitTop = -512
        camera.limitRight = 1024
        camera.limitLeft = -1024
        
        player.addChild(node: camera)
    }
    
    private func addBackgroundAndForeground(){
        if let bg:Texture2D = GD.load(path: "res://assets/rooms/JunkShop/bg.jpg") {
            background = Sprite2D()
            background.texture = bg
            background.zIndex = Constants.background_zIndex
            self.addChild(node: background)
        }
        
        if let fg:Texture2D = GD.load(path: "res://assets/rooms/JunkShop/fg.png") {
            foreground = Sprite2D()
            foreground.texture = fg
            foreground.zIndex = Constants.foreground_zIndex
            self.addChild(node: foreground)
        }
    }
    
    private func addBgMusic(){
        if let bgMusic:AudioStreamMP3 = GD.load(path: "res://assets/music/8bits-final.mp3") {
            let bgMusicPlayer = AudioStreamPlayer()
            bgMusic.loop = true
            bgMusicPlayer.stream = bgMusic
            addChild(node: bgMusicPlayer)
            bgMusicPlayer.play()
        }
    }
    
    private func addObjects() {
                        
        details = RoomDetails.load(path: "res://assets/rooms/JunkShop/JunkShop.json")
        details?.objects.forEach { object in
            guard let position = object.position else {
                GD.print("Object without position: \(object.name)")
                return
            }
            objects.append(Object(object))
            let shape = ColorRect()
            shape.setSize(Vector2(x: 100, y: 100))
            shape.setPosition(Vector2(stringLiteral: position))
            shape.modulate.alpha = 0.5
            addChild(node: shape)
        }        
    }
    
    private func addWalkPath(){            
        walkbox = Walkbox()
        if Constants.debug {
            addChild(node: walkbox.node)
        }
    }
    
}
