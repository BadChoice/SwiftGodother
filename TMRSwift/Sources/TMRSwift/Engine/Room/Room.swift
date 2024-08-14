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
    
    override required init(){
        super.init()
    }
    
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
    
    private func loadDetails(){
        let json = String("\(self)".split(separator: ".").last!.split(separator: ":").first!)
        details = RoomDetails.loadCached(path: "res://assets/rooms/" + json + ".json")
    }
        
    
    private func loadAtlas(){
        atlas = Cache.shared.cache(key: "room-texture-\(details.atlasName)") {
            let atlas = TexturePacker(path: "res://assets/rooms/" + details.atlasName + ".atlasc", filename: details.atlasName + ".plist")
            atlas.load()
            return atlas
        }
    }
    
    
    func putActor(at position:Vector2?, facing:Facing){
        camera.positionSmoothingEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { [weak self] in
            self?.camera.positionSmoothingEnabled = true
        }
        if let position {
            actor.node.position = position
            actor.setAwayScale(walkbox.getAwayScaleForActorAt(point: position))
        }
        actor.face(facing)
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
        camera.limitBottom = Int32(background.texture!.getSize().y / 2)
        camera.limitTop = -Int32(background.texture!.getSize().y / 2)
        camera.limitRight = Int32(background.texture!.getSize().x / 2)
        camera.limitLeft = -Int32(background.texture!.getSize().x / 2)
                
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
    

    private func addObjects() {
        objects = details.setup()
        objects.forEach {
            $0.addToRoom(self)
        }
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
    

    
    //MARK: - Music
    
    //MARK:- Music
    func playMusic(onlyFx:Bool = false){
        /*guard Constants.music else { return }
        if !onlyFx {
            if let sound = Sound.looped(music){
                musicNode = sound
                node?.parent?.addChild(sound.changeVolume(Constants.musicVolume))
            }
        }
        
        if let ambienceSound, ambienceSound.count > 0, let ambience = Sound.looped(ambienceSound, withExtension: "wav"){
            ambienceNode = ambience
            node?.parent?.addChild(ambience.changeVolume(Constants.ambienceVolume))
        }*/
    }
    
    func resumeMusicAndAmbience(){
        //musicNode?.run(.changeVolume(to: Constants.musicVolume, duration: 1))
        //ambienceNode?.run(.changeVolume(to: Constants.ambienceVolume, duration: 1))
    }
    
    
    func stopMusic(onlyFx:Bool = false){
        /*if !onlyFx {
            node?.parent?.removeAllSounds(fadeoutTime: 0.4)
        }
        ambienceNode?.removeFromParent()
        node?.children.forEach { $0.removeAllSounds() }*/
    }
    
    
    //MARK: - Helpers
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
