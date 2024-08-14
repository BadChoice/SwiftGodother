import SwiftGodot

@Godot
class Circle2D : Node2D {
    
    var radius:Double = 50
    var color:Color = .white
    
    override func _draw() {
        drawCircle(position:.zero, radius:radius, color:color)
    }
}
