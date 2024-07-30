import SwiftGodot

class Sound {
    static func play(once sound:String?, waitForCompletion:Bool = false, volume:Float = Constants.sfxVolume, node:Node2D? = nil, then:((()->Void))? = nil){
        /*guard let sound = sound else { return }
        
        let action = Cache.shared.cache(key: "single-sound-\(sound)") { () -> SKAction in
            let action             = SKAction.playSoundFileNamed(sound, waitForCompletion: waitForCompletion)
            let changeVolumeAction = SKAction.changeVolume(to: volume, duration: 0.0)
            return SKAction.group([action, changeVolumeAction])
        }
        //let action             = SKAction.playSoundFileNamed(sound, waitForCompletion: waitForCompletion)
        //let changeVolumeAction = SKAction.changeVolume(to: volume, duration: 0.0)
        
        (node ?? Game.shared.scene).run(action) {
            then?()
        }*/
    }
        
    static func looped(_ sound:String?, volume:Float = Constants.sfxVolume, withExtension:String = "mp3") -> Node2D? {
        /*guard let sound = sound else { return nil }
        guard let url = Bundle.main.url(forResource:sound, withExtension:withExtension) else { return nil }
        let soundNode = Cache.shared.cache(key: "sound-\(sound)-\(withExtension)") {
            return SKAudioNode(url:url)
        }
        soundNode.run(.changeVolume(to: volume, duration: 0.0))
        soundNode.removeFromParent()
        soundNode.autoplayLooped = true
        return soundNode
         */
        
        return nil
    }
}
