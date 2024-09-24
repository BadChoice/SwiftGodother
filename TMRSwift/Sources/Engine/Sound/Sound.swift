import SwiftGodot

class Sound {
    static func play(once sound:String?, waitForCompletion:Bool = false, volume:Double = Constants.sfxVolume, node:Node? = nil, then:((()->Void))? = nil){
        guard let sound = sound else { return }

        if let sound:AudioStreamMP3 = GD.load(path: "res://assets/sfx/" + sound + ".mp3") {
            let player = AudioStreamPlayer()
            sound.loop = false
            player.stream = sound
            player.volumeDb = GD.linearToDb(lin: volume)
            
            (node ?? Game.shared.scene).addChild(node:player)
            player.finished.connect {
                then?()
            }
            player.play()
        }
    }
        
    static func looped(_ sound:String?, folder:String = "sfx", volume:Double = Constants.sfxVolume, withExtension:String = "mp3") -> AudioStreamPlayer? {
        guard let sound = sound else { return nil }
                
        if withExtension == "wav" {
            if let sound:AudioStreamWAV = GD.load(path: "res://assets/\(folder)/" + sound + ".wav") {
                let player = AudioStreamPlayer()
                //sound.loop = true
                player.stream = sound
                player.volumeDb = GD.linearToDb(lin: volume)
                return player
            }
            return nil
        }
        
        if withExtension == "ogg"{
            if let sound:AudioStreamOggVorbis = GD.load(path: "res://assets/\(folder)/" + sound + ".ogg") {
                let player = AudioStreamPlayer()
                sound.loop = true
                player.stream = sound
                player.volumeDb = GD.linearToDb(lin: volume)
                return player
            }
            return nil
        }
        
        if let sound:AudioStreamMP3 = GD.load(path: "res://assets/\(folder)/" + sound + ".mp3") {
            let player = AudioStreamPlayer()
            sound.loop = true
            player.stream = sound
            player.volumeDb = GD.linearToDb(lin: volume)
            return player
        }
        
        return nil
    }
        
}
