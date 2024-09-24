import Foundation
import SwiftGodot

class NonPlayableCharacter : SpriteObject, Animable {
    
    override var verbTexts: [Verbs : String] {
        [.talk : "Talk with"]
    }
    
    var subsprites:[String:Sprite2D] = [:]
    var face:Sprite2D!
    var mouth:Sprite2D!    { subsprites["mouth"] }
    var eyes:Sprite2D!     { subsprites["eyes"] }
    
    override func createNode() {
        (scripts as? NpcScripts)?.createNode()
    }
    
    func animate(_ animation: String?) {
        
    }
    
    func face(_ facing: Facing) {
        
    }
}

protocol NpcScripts {
    func createNode()
    func animateNpc(_ animation:String?)
    var prefix: String { get }
}

extension NpcScripts where Self: ObjectScripts {
    var npc: NonPlayableCharacter {
        scriptedObject as! NonPlayableCharacter
    }
}

