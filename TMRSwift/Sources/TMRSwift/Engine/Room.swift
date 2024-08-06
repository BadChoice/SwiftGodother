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
        
        
        testLoader()
    }
    
    func testLoader(){
        let tp = TexturePacker(path: "res://assets/actors/crypto/crypto.atlasc", filename:"Crypto.plist")
        tp.load()
        
        let t1 = Sprite2D(texture: tp.textureNamed(name: "walk/01")!)
        let t2 = Sprite2D(texture: tp.textureNamed(name: "walk/02")!)
        let t3 = Sprite2D(texture: tp.textureNamed(name: "walk/03")!)
        let t4 = Sprite2D(texture: tp.textureNamed(name: "walk/04")!)
        let t5 = Sprite2D(texture: tp.textureNamed(name: "walk/05")!)
        let t6 = Sprite2D(texture: tp.textureNamed(name: "walk/06")!)
        let t7 = Sprite2D(texture: tp.textureNamed(name: "walk/07")!)
        let t8 = Sprite2D(texture: tp.textureNamed(name: "walk/08")!)
        
        t1.position = Vector2(x: -500, y: 200)
        t2.position = Vector2(x: -500, y: 200)
        t3.position = Vector2(x: -500, y: 200)
        t4.position = Vector2(x: -500, y: 200)
        t5.position = Vector2(x: -500, y: 200)
        t6.position = Vector2(x: -500, y: 200)
        t7.position = Vector2(x: -500, y: 200)
        t8.position = Vector2(x: -500, y: 200)
        
        
        t1.globalScale = Vector2(value: 2)
        t2.globalScale = Vector2(value: 2)
        t3.globalScale = Vector2(value: 2)
        t4.globalScale = Vector2(value: 2)
        t5.globalScale = Vector2(value: 2)
        t6.globalScale = Vector2(value: 2)
        t7.globalScale = Vector2(value: 2)
        t8.globalScale = Vector2(value: 2)
        
        node.addChild(node: t1)
        node.addChild(node: t2)
        node.addChild(node: t3)
        node.addChild(node: t4)
        node.addChild(node: t5)
        node.addChild(node: t6)
        node.addChild(node: t7)
        node.addChild(node: t8)
        
        
        
        /*let tp1 = tp.textureNamed(name: "idle/00")
        let tp2 = tp.textureNamed(name: "idle/00")
        
        GD.print("Textures size", tp1?.getSize(), tp2?.getSize())
        
        let animated = AnimatedSprite2D()
        
        animated.spriteFrames = SpriteFrames()
        animated.spriteFrames?.addAnimation(anim: "idle")
        animated.spriteFrames?.addFrame(anim: "idle", texture: tp.textureNamed(name: "idle/00"), duration: 2)
        animated.spriteFrames?.addFrame(anim: "idle", texture: tp.textureNamed(name: "idle/01"), duration: 2)
        
        animated.play(name: "idle")
        animated.globalScale = Vector2(value: 2)
        animated.position = Vector2(x: 500, y: 0)
        node.addChild(node: animated)*/
        
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
        details = RoomDetails.load(path: "res://assets/part3/JunkShop/JunkShop.json")
    }
        
    private func addWalkPath(){            
        walkbox = Walkbox(points: details.walkBoxes.first!)
        if Constants.debug {
            addChild(node: walkbox.node)
        }
    }
    
    public func addChild(node:Node){
        self.node.addChild(node: node)
    }
    
}
