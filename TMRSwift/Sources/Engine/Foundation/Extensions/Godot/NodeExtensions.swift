import SwiftGodot

extension Node {
    func removeFromParent(){
        getParent()?.removeChild(node: self)
    }
    
    func removeAllChildren(){
        getChildren().forEach { $0.removeFromParent() }
    }
    
    func removeAllSounds(fadeoutTime:Double = 0){
        getChildren().forEach{
            $0.removeAllSounds()
        }
        getChildren().filter {
            $0 is AudioStreamPlayer
        }.forEach {
            $0.removeFromParent()
        }
    }
    
    func shake(intensity:Float = 12, duration:Double = 0.2) {
        if hasActions() {
            return
        }
        run(.shake(
            amplitude: Vector2(value:intensity * Float(Game.shared.scale)),
            duration: duration
        ))
    }
}
