import Foundation


class NonPlayableCharacter : SpriteObject, Animable {
    
    override var verbTexts: [Verbs : String] {
        [.talk : "Talk with"]
    }
    
    func animate(_ animation: String?) {
        
    }
    
    func face(_ facing: Facing) {
        
    }
}
