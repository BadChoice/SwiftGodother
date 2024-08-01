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
    
    var tp:TexturePacker!
    
    override func _ready() {
        addBackgroundAndForeground()
        addBgMusic()
        addPlayer()
        setupCamera()
        addObjects()
        addWalkPath()
        
        tp = TexturePacker(path: "res://assets/part3/Part3.atlasc", filename:"Part3.plist")
        tp.load()
        
        if let texture = tp.textureNamed(name: "Dork/Dork-make-pizza-07.png") {
            let sprite = Sprite2D(texture: texture)
            sprite.zIndex = 100
            addChild(node: sprite)
        }
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
        if let bg:Texture2D = GD.load(path: "res://assets/part3/JunkShop/bg.jpg") {
            background = Sprite2D(texture: bg)
            background.zIndex = Constants.background_zIndex
            self.addChild(node: background)
        }
        
        if let fg:Texture2D = GD.load(path: "res://assets/part3/JunkShop/fg.png") {
            foreground = Sprite2D(texture: fg)
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
                        
        details = RoomDetails.load(path: "res://assets/part3/JunkShop/JunkShop.json")
        details?.objects.forEach { object in
            guard let position = object.position else {
                GD.print("Object without position: \(object.name)")
                return
            }
                        
            let finalObject = ShapeObject(object)
            addChild(node: finalObject.node)
            objects.append(finalObject)
        }
    }
        
    private func addWalkPath(){            
        walkbox = Walkbox(points: details.walkBoxes.first!)
        if Constants.debug {
            addChild(node: walkbox.node)
        }
    }
    
}
