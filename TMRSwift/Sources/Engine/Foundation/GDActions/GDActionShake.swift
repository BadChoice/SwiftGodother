import Foundation
import SwiftGodot

class GDActionShake : GDAction {
    
    let duration:Double
    let amplitude:Vector2
    let shakeDuration:Double
    
    var startPosition:Vector2!
    
    init(amplitude:Vector2, shakeDuration:Double, duration:Double){
        self.amplitude = amplitude
        self.shakeDuration = shakeDuration
        self.duration = duration
    }
    
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        addToList(node: node)
        startPosition = (node as? Node2D)?.position ?? (node as? Control)?.getPosition() ?? .zero
        
        let numberOfShakes  = duration / shakeDuration
        
        var actionsArray:[GDAction] = []
                
        for _ in 1...Int(numberOfShakes) {
            
            let randomX = Int.random(in: 0..<Int(amplitude.x))
            let randomY = Int.random(in: 0..<Int(amplitude.y))
            
            let newXPos = startPosition.x + Float(randomX) - Float(amplitude.x / 2)
            let newYPos = startPosition.y + Float(randomY) - Float(amplitude.y / 2)
            actionsArray.append(.move(to: Vector2(x:newXPos, y:newYPos), duration: shakeDuration))
        }
        actionsArray.append(.move(to:startPosition, duration: shakeDuration))
        
        node.run(.sequence(actionsArray)) { [self] in
            removeFromList()
            completion?()
        }
    }
}
