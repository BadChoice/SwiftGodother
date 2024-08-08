import Foundation


class NonPlayableCharacter : SpriteObject, Animable {
    
    override var verbTexts: [Verbs : String] {
        [.talk : "Talk with"]
    }
    
    @objc dynamic func animate(_ animation: String?) {
        
    }
    
    func face(_ facing: Facing) {
        
    }
}
