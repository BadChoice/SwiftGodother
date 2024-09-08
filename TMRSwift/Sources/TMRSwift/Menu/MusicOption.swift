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
        Settings.shared.musicEnabled = !Settings.shared.musicEnabled
        Settings.shared.save()
        label.text   = Self.getText()
                
        if Settings.shared.musicEnabled {
            Game.shared.room.playMusic()
        } else {
            Game.shared.room.stopMusic()
        }
        
        return false
    }
    
    static func getText() -> String {
        __("Music") + ": " + (Settings.shared.musicEnabled ? __("On") : __("Off"))
    }
    
}
