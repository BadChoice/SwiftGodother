import SwiftGodot
import Foundation

class Room : ProvidesState {
        
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
    
    var scripts:RoomScripts!
    
    
    var actorType:Actor.Type { scripts.actorType }
    
    //MARK: - Lifecycle
    func onEnter(){ scripts.onEnter() }
    func onExit(){ scripts.onExit() }
    
    required init(){
        
    }
    
    //MARK: - Load
    func _ready() {
        loadScripts()
        loadDetails()
        loadAtlas()
        
        addBackgroundAndForeground()
        addActor()
        addObjects()
        addWalkPath()
        setupCamera()
    }
    
    func loadScripts(){
        scripts = (NSClassFromString(safeClassName("\(Self.self)Scripts")) as? RoomScripts.Type)?.init(room: self) ?? RoomScripts(room: self)
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
        actor.node.zIndex = 1
        actor.node.removeFromParent()
        addChild(node: actor.node)
        actor.face(facing)
        actor.animate(nil)
    }
    
    private func addActor(){
        let crypto = Cache.shared.cache(key:"Crypto") { Crypto() }
        //let crypto = Cache.shared.cache(key:"Crypto") { Actor() }
        actor = crypto
        //actor = Crypto()
        //actor = Actor()
        //actor.node.modulate = actor.node.modulate.darkened(amount: 0.5)
    }
    
    private func setupCamera(){
        camera.positionSmoothingEnabled = false
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
        guard Settings.shared.musicEnabled else { return }
        
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
    
    func zoomIn(to value:Float = 1.02){
        node.run(.scale(to: value, duration:1).withTimingMode(.out))
    }
    
    func zoomOut(from value:Float = 0.98){
        node.run(.sequence([
            .scale(to: value, duration:0),
            .scale(to: 1, duration:1).withTimingMode(.out)
        ]))
    }
}
