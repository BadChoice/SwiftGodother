import Foundation
import SwiftGodot

class MusicOption : Menu.Option{
        
    init(){
        super.init(text: Self.getText())
    }
    
    override func touched(at point: Vector2) -> Bool {
        if label.hasPoint(point){
            return perform(Node())
        }
        return true
    }
    
    override func perform(_ node:Node) -> Bool {
        Settings.musicEnabled = !Settings.musicEnabled
        label.text   = Self.getText()
        //UserDefaults.standard.setValue(Constants.music, forKey: "music")
        
        if Settings.musicEnabled {
            Game.shared.room.playMusic()
        } else {
            Game.shared.room.stopMusic()
        }
        
        return false
    }
    
    static func getText() -> String {
        __("Music") + ": " + (Settings.musicEnabled ? __("On") : __("Off"))
    }
    
}
