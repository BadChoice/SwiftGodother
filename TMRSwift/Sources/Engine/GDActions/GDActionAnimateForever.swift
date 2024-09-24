import Foundation
import SwiftGodot

class GDActionAnimateForever : GDAction {
    
    var textures: [Texture2D]
    let timePerFrame:Double
    var currentIndex = 0
    var shouldFinish:Bool = false
    
    init(_ textures:[Texture2D], timePerFrame:Double){
        self.textures = textures
        self.timePerFrame = timePerFrame
    }
    
    override func run(_ node: Node, completion: (() -> Void)?) {
        guard node.getParent() != nil, let sprite = node as? Sprite2D else {
            completion?()
            return
        }
        
        addToList(node: node)
        sprite.texture = textures[currentIndex]
        DispatchQueue.main.asyncAfter(deadline: .now() + timePerFrame) { [self] in
            showNextTexture(sprite)
        }
    }
    
    private func showNextTexture(_ sprite:Sprite2D){
        if shouldFinish {
            textures.removeAll()
            return
        }
        
        currentIndex = (currentIndex + 1) % textures.count
        sprite.texture = textures[currentIndex]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timePerFrame) { [self] in
            showNextTexture(sprite)
        }
    }
    
    override func stop(){
        super.stop()
        shouldFinish = true
    }
    
    
}
