import SwiftGodot
import Foundation

class Room : NSObject, ProvidesState {
        
    var node = Node2D()
    var actor:Actor!
    var background:Sprite2D!
    var foreground:Sprite2D!
    
    var bgMusicPlayer       = AudioStreamPlayer()
    var ambienceMusicPlayer = AudioStreamPlayer()
    
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
        addActor()
        setupCamera()
        addObjects()
        addWalkPath()
        putActor(at: Vector2(x:0, y:400) * Game.shared.scale, facing: .right)
    }
    
    func loadDetails(){
        let json = String("\(self)".split(separator: ".").last!.split(separator: ":").first!)
        details = RoomDetails.loadCached(path: "res://assets/rooms/" + json + ".json")
    }
        
    
    private func loadAtlas(){
        let atlas:TexturePacker = Cache.shared.cache(key: "atlas-\(details.atlasName)") {
            let atlas = TexturePacker(path: "res://assets/rooms/" + details.atlasName + ".atlasc", filename: details.atlasName + ".plist")
            atlas.load()
            return atlas
        }
        self.atlas = atlas
    }
    
    
    func putActor(at point:Vector2?, facing:Facing){
        camera.positionSmoothingEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) { [weak self] in
            self?.camera.positionSmoothingEnabled = true
        }
        if let point {
            actor.node.position = point
            actor.setAwayScale(walkbox.getAwayScaleForActorAt(point: point))
        }
        actor.face(facing)
    }
    
    private func addActor(){
        actor = Crypto()
        actor.node.zIndex = 1
        addChild(node: actor.node)
        //actor.node.modulate = actor.node.modulate.darkened(amount: 0.5)
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
    func playMusic(onlyFx:Bool = false){
        guard Settings.musicEnabled else { return }
        
        if !onlyFx {
            if let sound = Sound.looped(details.music, folder:"music"){
                bgMusicPlayer = sound
                node.getParent()?.addChild(node: sound)
                bgMusicPlayer.play()
            }
        }
        
        if let ambienceSound = details.ambienceSound, ambienceSound.count > 0, let ambience = Sound.looped(ambienceSound, withExtension: "ogg"){
            ambienceMusicPlayer = ambience
            node.getParent()?.addChild(node: ambience)
            ambienceMusicPlayer.play()
        }
    }
    
    func resumeMusicAndAmbience(){
        bgMusicPlayer.volumeDb = GD.linearToDb(lin: Constants.musicVolume)
        ambienceMusicPlayer.volumeDb = GD.linearToDb(lin: Constants.ambienceVolume)
    }
        
    func stopMusic(onlyFx:Bool = false){
        if !onlyFx {
            node.getParent()?.removeAllSounds(fadeoutTime: 0.4)
        }
        ambienceMusicPlayer.stop()
        ambienceMusicPlayer.removeFromParent()
        node.getChildren().forEach { $0.removeAllSounds() }
    }
    
    
    //MARK: - Helpers
    public func addChild(node:Node){
        self.node.addChild(node: node)
    }
    
    
}
