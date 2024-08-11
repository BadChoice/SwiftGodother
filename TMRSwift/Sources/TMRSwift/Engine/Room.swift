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
    
    //MARK: - Lifecycle
    @objc dynamic func onEnter(){ }
    @objc dynamic func onExit(){ }
    
    //MARK: - Load
    func _ready() {
        loadDetails()
        loadAtlas()
        
        addBackgroundAndForeground()
        //addBgMusic()
        addActor()
        setupCamera()
        addObjects()
        addWalkPath()
        
        //addTest()
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
                                
        objects = details.setup()
        
        objects.forEach {
            $0.addToRoom(self)
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
    
    
    /*private func addTest(){
        let tp = TexturePacker(path: "res://assets/actors/crypto/crypto.atlasc", filename:"Crypto.plist")
        tp.load()
        tp.debug = true
        
        let idle1     = Sprite2D(texture: tp.textureNamed(name: "idle/00")!)
        let noFace    = Sprite2D(texture: tp.textureNamed(name: "no-face")!)
        let pickupLow = Sprite2D(texture: tp.textureNamed(name: "pickup/low")!)
        
        GD.print(idle1.getRect(), noFace.getRect(), pickupLow.getRect())
        
        addChild(node: idle1)
        addChild(node: noFace)
        addChild(node: pickupLow)
        
        idle1.position = Vector2(x:-600, y:0)
        pickupLow.position = .zero
        noFace.position = Vector2(x:600, y:0)
        
        let idle1Rect = ColorRect()
        idle1Rect.setPosition(idle1.position - idle1.getRect().size / 2)
        idle1Rect.setSize(idle1.getRect().size)
        idle1Rect.modulate.alpha = 0.2
        addChild(node: idle1Rect)
        
        let noFaceRect = ColorRect()
        noFaceRect.setPosition(noFace.position - noFace.getRect().size / 2)
        noFaceRect.setSize(noFace.getRect().size)
        noFaceRect.modulate.alpha = 0.2
        addChild(node: noFaceRect)
        
        let pickupLowRect = ColorRect()
        pickupLowRect.setPosition(pickupLow.position - pickupLow.getRect().size / 2)
        pickupLowRect.setSize(pickupLow.getRect().size)
        pickupLowRect.modulate.alpha = 0.2
        addChild(node: pickupLowRect)
    }*/
    
}
