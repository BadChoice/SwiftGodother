import SwiftGodot
import Foundation


class Room {
        
    var node = Node2D()
    var player:Player!
    var background:Sprite2D!
    var foreground:Sprite2D!
    var bgMusic:AudioStreamPlayer!
    
    var details:RoomDetails!
    
    var walkbox:Walkbox!
    var objects:[Object] = []
    var camera = Camera2D()
    
    var atlas:TexturePacker!
    
    func _ready() {
        loadDetails()
        loadAtlas()
        
        addBackgroundAndForeground()
        //addBgMusic()
        addPlayer()
        setupCamera()
        addObjects()
        addWalkPath()
    }
    
    
    private func addPlayer(){
        player = Crypto()
        player.node.zIndex = 1
        addChild(node: player.node)
    }
    
    private func setupCamera(){
        camera.positionSmoothingEnabled = true
        camera.positionSmoothingSpeed = 1.0
        
        camera.limitSmoothed = true
        camera.limitBottom = 1024
        camera.limitTop = -1024
        camera.limitRight = 2048
        camera.limitLeft = -2048
                
        
        player.node.addChild(node: camera)
    }
    
    private func addBackgroundAndForeground(){
        
        background = Sprite2D(path: "res://assets/part3/JunkShop/bg.jpg")
        background.zIndex = Constants.background_zIndex
        addChild(node: background)
                
        foreground = Sprite2D(path: "res://assets/part3/JunkShop/fg.png")
        foreground.zIndex = Constants.foreground_zIndex
        addChild(node: foreground)
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
    
    private func loadAtlas(){
        atlas = TexturePacker(path: "res://assets/part3/Part3.atlasc", filename:"Part3.plist")
        atlas.load()
    }
    
    private func addObjects() {
                                
        details?.objects.forEach { object in
            
            if let objectType = NSClassFromString(safeClassName(object.objectClass)) as? Object.Type {
                let finalObject = objectType.init(object)
                if let node = finalObject.getNode() {
                    addChild(node: node)
                }
                objects.append(finalObject)
                return
            }
                    
            guard let position = object.position else {
                GD.print("Object without position: \(object.name)")
                return
            }
                        
            let finalObject = ShapeObject(object)
            addChild(node: finalObject.node)
            objects.append(finalObject)
        }
    }
    
    private func loadDetails(){
        details = RoomDetails.loadCached(path: "res://assets/part3/JunkShop/JunkShop.json")
    }
        
    private func addWalkPath(){        
        walkbox = Walkbox(
            points: details.walkBoxes.first!,
            frontScale: details.frontZScale,
            backScale: details.backZScale
        )
        
        if Constants.debug {
            addChild(node: walkbox.node)
        }
    }
    
    public func addChild(node:Node){
        self.node.addChild(node: node)
    }
    
}
