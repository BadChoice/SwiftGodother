import Foundation
import SwiftGodot

class Cursor {

    var node        = Node2D()
    var cursorNode  = Sprite2D(path: "res://assets/ui/cursor.png")
    var arrowNode   = Sprite2D(path: "res://assets/ui/arrow.png")
    
    init(){
        
        if OS.getName() == "iOS" || OS.getName() == "Android" {
            node.modulate.alpha = 0
        }
        
        node.zIndex = Constants.cursor_zIndex
        node.addChild(node: arrowNode)
        node.addChild(node: cursorNode)
        hideArrow()
    }
        
    func showArrow(_ angle:Double){
        cursorNode.modulate.alpha = 0
        arrowNode.modulate.alpha = 1
        //arrowNode.zRotation = CGFloat(angle)
    }
    
    func hideArrow() {
        cursorNode.modulate.alpha = 1
        arrowNode.modulate.alpha = 0
    }
    
    func onMouseMoved(at point:Vector2){
        node.position = point
        //Input.mouseMode = node.getViewportRect().hasPoint(node.getViewport()!.getMousePosition()) ? .visible : .hidden
        
        if node.getViewportRect().hasPoint(node.getViewport()!.getMousePosition()) {
            Input.mouseMode = .hidden
            //GD.print("INSIDE")
        }else{
            Input.mouseMode = .visible
            //GD.print("OUTSIDE")
        }
    }
}
