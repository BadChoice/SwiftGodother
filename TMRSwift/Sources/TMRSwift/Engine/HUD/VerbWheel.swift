import SwiftGodot

class VerbWheel {
    
    let node  = Node2D()
    var hack  = Sprite2D()
    var talk  = Sprite2D()
    var use   = Sprite2D()
    var look  = Sprite2D()
    var label = Label()
    
    var verbs:[Sprite2D]!
    var object:Object?
    
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
        label.text = "--"
        
        node.addChild(node: hack)
        node.addChild(node: talk)
        node.addChild(node: use)
        node.addChild(node: look)
        node.addChild(node: label)
        
        verbs = [hack, talk, use, look]
        
        node.hide()
    }
    
    var isOpen : Bool {
        node.isVisibleInTree()
    }
    
    func show(at position:Vector2, for object:Object){
        node.show()
        node.position = position
        label.text = __(object.name)
        self.object = object
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if isOpen {
            let localPosition = node.toLocal(globalPoint: position)
            if let verb = verbs.first (where: {
                return $0.rectInParent().hasPoint(localPosition)
            }){
                doVerb(verb)
            }
            
            node.hide()
            object = nil
            return true
        }
        return false
    }
    
    
    private func doVerb(_ verb:Sprite2D){
        GD.print("DO verb")
        switch verb {
        case hack:  object?.onPhoned()
        case talk:  object?.onMouthed()
        case use:   object?.onUse()
        case look:  object?.onLookedAt()
        default: return
        }
    }


}
