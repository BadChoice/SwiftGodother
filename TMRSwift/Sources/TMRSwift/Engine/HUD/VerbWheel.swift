import SwiftGodot

class VerbWheel : HandlesTouch {
    
    let node  = Node2D()
    var hack  = Sprite2D()
    var talk  = Sprite2D()
    var use   = Sprite2D()
    var look  = Sprite2D()
    var label = Label()
    
    init(){
        node.zIndex = Constants.verbwheel_zIndex
        
        hack.texture = GD.load(path: "res://assets/ui/verbwheel/hack.png")
        talk.texture = GD.load(path: "res://assets/ui/verbwheel/talk.png")
        use.texture  = GD.load(path: "res://assets/ui/verbwheel/use.png")
        look.texture = GD.load(path: "res://assets/ui/verbwheel/look.png")
        
        use.position  = Vector2(x: -185, y: -30)
        look.position = Vector2(x: -75, y: -160)
        talk.position = Vector2(x: 75,  y: -160)
        hack.position = Vector2(x: 185, y: -30)
        
        label.setPosition(Vector2(x:0, y: -260))
        label.text = "PATATA"
        
        node.addChild(node: hack)
        node.addChild(node: talk)
        node.addChild(node: use)
        node.addChild(node: look)
        node.addChild(node: label)
        
        node.hide()
    }
    
    var isOpen : Bool {
        node.isVisibleInTree()
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if isOpen {
            node.hide()
            return true
        }
        return false
    }
    
    func onLongPressed(at position:Vector2) -> Bool {
        node.show()
        node.position = position
        return true
    }
    
    

}
