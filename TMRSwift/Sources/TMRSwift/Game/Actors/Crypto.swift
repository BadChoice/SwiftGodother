import SwiftGodot

class Crypto : Actor {
     
    lazy var tp:TexturePacker = {
        Cache.shared.cache(key: "TPCrypto") {
            let tp = TexturePacker(path: "res://assets/actors/crypto/crypto.atlasc", filename:"crypto.plist")
            tp.load()
            return tp
        }
    }()
    
    var face = Sprite2D()
    var eyes = Sprite2D()
    var mouth = Sprite2D()
    var extra = Sprite2D()
    //var shadow =
    
    var facePosition : Point {
        if facing == .front { return Point(x: -14, y: -240) }
        return Point(x:-6, y:-236)
    }
    
    var eyesPosition : Point {
        if facing == .front { return Point(x:-4.5, y:-5.5) }
        return Point(x:5, y:-12)
    }
    
    var mouthPosition : Point {
        if facing == .front { return Point(x:-3, y:19) }
        return Point(x:10, y:18)
    }
    
    
    override init() {
        super.init()
        loadAnimations()
    }
    
    func loadAnimations(){
        frames = SpriteFrames()
        
        frames.createAnimation(name: "walk",    prefix: "walk/",    frames: 1...8, atlas:tp, timePerFrame:0.5, looped:true)
        frames.createAnimation(name: "combine", prefix: "combine/", frames: 0...17, atlas: tp, timePerFrame: 0.5, looped: false)
    
        frames.createAnimation(name: "idle", prefix: "idle/", frames: 0...1, atlas: tp, timePerFrame: 2.50, looped: true)
        
        frames.createSingleFrameAnimation(name:"no_face_profile", textureName: "no-face", atlas:tp)
        frames.createSingleFrameAnimation(name:"no_right_hand",   textureName: "no-right-hand", atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup",          textureName: "pickup/normal", atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-low",      textureName: "pickup/low", atlas:tp)
        
        frames.addAnimation(anim: "pickup-up")
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed("pickup/normal"), duration: 0.4)
        frames.addFrame(anim: "pickup-up", texture: tp.textureNamed("pickup/up"), duration: 0.4)
        frames.setAnimationLoop(anim: "pickup-up", loop: false)
        
        frames.addAnimation(anim: "pickup-really-up")
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed("pickup/normal"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed("pickup/up"), duration: 0.5)
        frames.addFrame(anim: "pickup-really-up", texture: tp.textureNamed("pickup/really-up"), duration: 0.5)
        frames.setAnimationLoop(anim: "pickup-really-up", loop: false)
                
        
        frames.createSingleFrameAnimation(name:"front",              textureName: "front-no-face",          atlas:tp)
        frames.createSingleFrameAnimation(name:"back",               textureName: "back-no-face",           atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-pickup", textureName: "pickup/pickup-back",     atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-up",     textureName: "pickup/pickup-back-up",  atlas:tp)
        frames.createSingleFrameAnimation(name:"pickup-back-low",    textureName: "pickup/pickup-back-low", atlas:tp)
        
        //puzzles/hand-lightgun-dark.png
        
        //no-right-hand.png
        //no-face
        
        //puzzles/hand-spiral-01 - 03

        //talk/face-look-phone.png
                        
        face.texture = tp.textureNamed("talk/face")
        face.position = facePosition * Game.shared.scale
        node.addChild(node: face)
        face.hide()
        
        eyes.texture = tp.textureNamed("expressions/eyes/star")
        eyes.zIndex = 1
        face.addChild(node: eyes)
        eyes.position = eyesPosition * Game.shared.scale
        
        mouth.texture = tp.textureNamed("expressions/mouth/happy")
        mouth.zIndex = 1
        mouth.position = mouthPosition * Game.shared.scale
        face.addChild(node: mouth)
        
        node.spriteFrames = frames
        
        node.offset.y = -frames.getFrameTexture(anim: "walk", idx: 0)!.getSize().y / 2 + (20 * Float(Game.shared.scale))
        node.play(name: "walk")
    }
    

    //---------------------------------------------------
    //MARK: - Animations
    //---------------------------------------------------
    override func animate(_ animation: String?) {
        clearAnimations()
        
        if animation?.contains("pickup") ?? false {
            return animatePickup(animation!)
        }
        
        switch animation {
        case "talk"                      : animateTalk()
        case Self.withBalloon.name       : animateWithBalloon()
        case Self.handToMouth.name       : animateHandToMouth()
        case Self.combine.name           : animateCombine()
        default: animateIdle()
        }
    }
    
    private func clearAnimations() {
        node.removeAllActions()
        face.removeAllActions()
        face.hide()
        face.rotation = 0
        setExpression(mouth: .happy)
        extra.removeAllActions()
        extra.removeFromParent()
        
        mouth.removeAllActions()
    }

    private func animateIdle(){
        if facing == .back  { return face(.back) }
        if facing == .front { return face(.front) }
        
        node.play(name: "idle")
    }
    
    private func animateTalk(){
        face.show()
        if facing == .back  {
            node.play(name: "back")
            face.animateForever([
                tp.textureNamed("talk/face-back")!,
                tp.textureNamed("talk/face-back")!,
                tp.textureNamed("talk/face-back-talk")!,
            ], timePerFrame: 0.2)
            mouth.hide()
            return
        }
        
        if facing == .front {
            face.show()
            node.play(name: "front")
            face.run(.repeatForever(.sequence([
                .wait(forDuration: 0.8),
                .moveBy(x: 0, y: 1, duration: 0),
                .wait(forDuration: 0.2),
                .moveBy(x: 0, y: -1, duration: 0)
            ])))
            
            face.set(texture: tp.textureNamed("talk/face-front"))
            mouth.show(withTexture: tp.textureNamed("expressions/mouth-front/00")!)
            mouth.animateForever([
                tp.textureNamed("expressions/mouth-front/00")!,
                tp.textureNamed("expressions/mouth-front/02")!,
                tp.textureNamed("expressions/mouth-front/01")!,
                //sheet.expressions_mouth_front_03(),
            ], timePerFrame: 0.2)
            return
        }
        
        node.play(name: "no_face_profile")
        face.animateForever([
            tp.textureNamed("talk/face")!,
            tp.textureNamed("talk/face")!,
            tp.textureNamed("talk/face-jaw-open")!
        ], timePerFrame: 0.2)
                       
        face.run(.repeatForever(.sequence([
            .rotate(toAngle: 0, duration: 0),
            .wait(forDuration: 0.2),
            .rotate(toAngle: 0.08, duration: 0),
            .wait(forDuration: 0.4)
        ])))
        mouth.show()
        mouth.run(.repeatForever(.sequence([
           .fadeAlpha(to: 0, duration: 0),
           .wait(forDuration: 0.2),
           .fadeAlpha(to: 1, duration: 0),
           .wait(forDuration: 0.2),
           .fadeAlpha(to: 0, duration: 0),
           .wait(forDuration: 0.2)
        ])))
    }
    
    private func animatePickup(_ animation:String){
        if facing == .back {
            face.show()
            return node.play(name: StringName("pickup-back-\(animation)"))
        }
        node.play(name: StringName(animation))
    }
    
    private func animateHandToMouth(){
        face.show()
        face.texture   = tp.textureNamed("talk/face")
        extra.texture  = tp.textureNamed("puzzles/hand-to-mouth")
        extra.position = Vector2(x:35, y:188) * Game.shared.scale
        extra.zIndex    = 10
        //extra.setScale(1)
        node.play(name: "no_right_hand")
        node.addChild(node: extra)
    }
    
    private func animateCombine(){
        if [.front, .back].contains(facing) { face(.right) }
        face.hide()
        node.play(name: "combine")
    }
    
    //---------------------------------------------------
    //MARK: - Puzzle animations
    //---------------------------------------------------
    private func animateWithBalloon(){
        face.show()
        face.texture   = tp.textureNamed("talk/face")
        extra.texture  = texture("with-balloon")
        extra.position = Vector2(x:50, y:210) * Game.shared.scale
        extra.zIndex   = 10
        //extra.setScale(Vector0.5)
        node.play(name: "no_right_hand")
        node.addChild(node: extra)
    }
    
    //---------------------------------------------------
    //MARK: - Facing
    //---------------------------------------------------
    override func face(_ facing: Facing) {
        self.facing = facing
                        
        face.position  = facePosition * Game.shared.scale
        eyes.position  = eyesPosition * Game.shared.scale
        mouth.position = mouthPosition * Game.shared.scale
        
        if walk?.walkingTo != nil {
            node.play(name: "walk")
            face.hide()
            return
        } else {
            node.play(name: "idle")
        }
        
        if [.left, .right].contains(facing) {
            face.hide()
            if facing == .left && node.scale.x < 0  { return }
            if facing == .right && node.scale.x > 0 { return }
            
            node.scale.x *= -1
        }
        
        face.show()

        if facing == .front {
            node.play(name: "front")
            face.show(withTexture: tp.textureNamed("talk/face-front")!)
            eyes.hide()
            mouth.hide()
        }
        if facing == .back  {
            node.play(name: "back")
            face.show(withTexture: tp.textureNamed("talk/face-back")!)
            eyes.hide()
            mouth.hide()
        }
        
    }
    
    private func getFacingScale() -> Vector2 {
        switch facing {
        case .left, .backLeft, .frontLeft: Vector2(x: -1, y: 1)
        default: Vector2(x: 1, y: 1)
        }
    }
    
    override func setAwayScale(_ scale: Float) {
        node.scale = Vector2(x: scale, y:scale) * getFacingScale()
    }
    
    override func stopWalk() {
        super.stopWalk()
        node.play(name: "idle")
    }
    
    //---------------------------------------------------
    //MARK: - Face Expressions
    //---------------------------------------------------
    override func setExpression(eyes: Expression?) {
        guard let texture = eyesTexture(for: eyes) else {
            return self.eyes.hide()
        }
        self.eyes.show(withTexture: texture)
    }
    
    override func setExpression(mouth: Expression?) {
        guard let texture = mouthTexture(for: mouth) else {
            return// self.mouth.hide()
        }
        self.mouth.show(withTexture: texture)
    }
    
    private func eyesTexture(for expression:Expression?) -> Texture2D? {
        if facing == .back { return nil }
        guard let expression else { return nil }
        
        if facing == .front {
            switch expression {
            case .happy:                   return tp.textureNamed("expressions/eyes-front/happy")
            case .happy1,.happy2:          return tp.textureNamed("expressions/eyes-front/happy2")
            case .angry, .angry1, .angry2: return tp.textureNamed("expressions/eyes-front/sad")
            case .bored:                   return tp.textureNamed("expressions/eyes-front/sad")
            case .focus:                   return tp.textureNamed("expressions/eyes-front/suspicious")
            case .sad:                     return tp.textureNamed("expressions/eyes-front/sad")
            case .suspicious:              return tp.textureNamed("expressions/eyes-front/suspicious")
            case .ouch:                    return tp.textureNamed("expressions/eyes-front/sad")
            case .blink:                   return tp.textureNamed("expressions/eyes-front/blink")
            case .surprise:                return nil
            case .love:                    return tp.textureNamed("expressions/eyes-front/love")
            case .star:                    return tp.textureNamed("expressions/eyes-front/love")
            case .small:                   return tp.textureNamed("expressions/eyes-front/small")
            }
        }
        switch expression {
            case .happy:                   return tp.textureNamed("expressions/eyes/happy")
            case .happy1,.happy2:          return tp.textureNamed("expressions/eyes/happy_mid")
            case .angry, .angry1, .angry2: return tp.textureNamed("expressions/eyes/angry")
            case .bored:                   return tp.textureNamed("expressions/eyes/bored")
            case .focus:                   return tp.textureNamed("expressions/eyes/focus")
            case .sad:                     return tp.textureNamed("expressions/eyes/sad")
            case .suspicious:              return tp.textureNamed("expressions/eyes/suspicious")
            case .ouch:                    return tp.textureNamed("expressions/eyes/sad")
            case .blink:                   return tp.textureNamed("expressions/eyes/none")
            case .surprise:                return nil
            case .love:                    return tp.textureNamed("expressions/eyes/love1")
            case .star:                    return tp.textureNamed("expressions/eyes/star")
            case .small:                   return tp.textureNamed("expressions/eyes/small")
        }
    }
    
    private func mouthTexture(for expression:Expression?) -> Texture2D? {
        if facing == .back || facing == .front { return nil }
        guard let expression else { return nil }
        switch expression {
        case .happy:      return tp.textureNamed("expressions/mouth/happy-simple")
        case .happy1:     return tp.textureNamed("expressions/mouth/happy")
        case .happy2:     return tp.textureNamed("expressions/mouth/happy_2")
        case .angry:      return tp.textureNamed("expressions/mouth/angry")
        case .angry1:     return tp.textureNamed("expressions/mouth/angry_1")
        case .angry2:     return tp.textureNamed("expressions/mouth/angry_2")
        case .bored:      return tp.textureNamed("expressions/mouth/sad")
        case .focus:      return tp.textureNamed("expressions/mouth/semi")
        case .sad:        return tp.textureNamed("expressions/mouth/sad")
        case .suspicious: return tp.textureNamed("expressions/mouth/semi")
        case .surprise:   return tp.textureNamed("expressions/mouth/surprise")
        case .ouch:       return tp.textureNamed("expressions/mouth/ouch")
        case .love:       return tp.textureNamed("expressions/mouth/happy")
        case .star:       return tp.textureNamed("expressions/mouth/happy_2")
        case .small:      return tp.textureNamed("expressions/mouth/round")
        case .blink:      return nil
        }
    }
    
    //---------------------------------------------------
    //MARK: - Arm Expressions
    //---------------------------------------------------
        
    //---------------------------------------------------
    //MARK: - Animations
    //---------------------------------------------------
    static var combine:  Animation {
        .init(name: "combine", durationMs: 18 * 100, sound:"combine_items")
    }
    
    static var withBalloon: Animation {
        .init(name: "with-balloon", durationMs: 2000, sound:"show_balloon")
    }
                        
    static var handToMouth: Animation {
        .init(name: "hand-to-mouth", durationMs: 1000, sound:nil)
    }
}
