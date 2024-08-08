import SwiftGodot
import Foundation


class Room : NSObject, ProvidesState {
        
    var node = Node2D()
    var actor:Actor!
    var background:Sprite2D!
    var foreground:Sprite2D!
    var bgMusic:AudioStreamPlayer!
    
    var details:RoomDetails!
    
    var walkbox:Walkbox!
    var objects:[Object] = []
    var camera = Camera2D()
    
    var atlas:TexturePacker!
    
    
    @objc dynamic var actorType:Actor.Type { Crypto.self }
    
    func _ready() {
        loadDetails()
        loadAtlas()
        
        addBackgroundAndForeground()
        //addBgMusic()
        addActor()
        setupCamera()
        addObjects()
        addWalkPath()
    }
    
    
    private func addActor(){
        actor = Crypto()
        actor.node.zIndex = 1
        addChild(node: actor.node)
    }
    
    private func setupCamera(){
        camera.positionSmoothingEnabled = true
        camera.positionSmoothingSpeed = 1.0
        
        camera.limitSmoothed = true
        camera.limitBottom = 1024
        camera.limitTop = -1024
        camera.limitRight = 2048
        camera.limitLeft = -2048
                
        
        actor.node.addChild(node: camera)
    }
    
    private func addBackgroundAndForeground(){
        
        background = Sprite2D(path: "res://assets/rooms/" + details.background + ".jpg")
        background.zIndex = Constants.background_zIndex
        addChild(node: background)
                
        if let foregroundName = details.foreground {
            foreground = Sprite2D(path: "res://assets/rooms/" + foregroundName + ".png")
            foreground.zIndex = Constants.foreground_zIndex
            addChild(node: foreground)
        }
    }
    
    private func addBgMusic(){
        guard let musicName = details.music else { return }
        if let bgMusic:AudioStreamMP3 = GD.load(path: "res://assets/music/" + musicName + ".mp3") {
            let bgMusicPlayer = AudioStreamPlayer()
            bgMusic.loop = true
            bgMusicPlayer.stream = bgMusic
            addChild(node: bgMusicPlayer)
            bgMusicPlayer.play()
        }
    }
    
    private func loadAtlas(){
        atlas = TexturePacker(path: "res://assets/rooms/" + details.atlasName + ".atlasc", filename: details.atlasName + ".plist")
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
        let json = String("\(self)".split(separator: ".").last!.split(separator: ":").first!)
        details = RoomDetails.loadCached(path: "res://assets/rooms/" + json + ".json")
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
