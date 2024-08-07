import SwiftGodot

class VerbWheel {
    
    let node  = Node2D()
    var hack:Sprite2D!
    var talk:Sprite2D!
    var use :Sprite2D!
    var look:Sprite2D!
    var label = Label()
    
    var verbs:[Sprite2D]!
    var object:Object?
    
    init(){
        node.zIndex = Constants.verbwheel_zIndex
        
        hack = Sprite2D(path: "res://assets/ui/verbwheel/hack.png")
        talk = Sprite2D(path: "res://assets/ui/verbwheel/talk.png")
        use  = Sprite2D(path: "res://assets/ui/verbwheel/use.png")
        look = Sprite2D(path: "res://assets/ui/verbwheel/look.png")
        
        use.position  = Vector2(x: -185, y: -30) * Game.shared.scale
        look.position = Vector2(x: -75, y: -160) * Game.shared.scale
        talk.position = Vector2(x: 75,  y: -160) * Game.shared.scale
        hack.position = Vector2(x: 185, y: -30) * Game.shared.scale
        
        makeLabel()
        label.setPosition(Vector2(x:0, y: -300) * Game.shared.scale)
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
        node.scale.x == 1
    }
    
    func show(at position:Vector2, for object:Object){
        verbs.forEach { $0.scale = .one }
        node.show()
        node.position = position
        
        self.object = object
        
        label.text = __(object.name)
        label.offsetLeft = Double(-label.getSize().x / 2)
        
        node.scale = .zero
        node.run(.scale(to: 1, duration: 0.1))
    }
    
    private func hide(){
        object = nil
        node.run(.scale(to: 0, duration: 0.1)) { [unowned self] in
            node.scale = .zero
            node.hide()
        }
    }
    
    func onTouched(at position:Vector2, shouldHide:Bool = true) -> Bool {
        guard isOpen else { return false }
        
        let localPosition = node.toLocal(globalPoint: position)
        if let verb = verb(at: localPosition) {
            doVerb(verb)
        }
        
        if shouldHide {
            hide()
        }
        return true
    }
    

    
    func onMouseMoved(at position:Vector2) -> Bool {
        guard isOpen else { return false }
        
        let localPosition = node.toLocal(globalPoint: position)
        verbs.forEach { $0.globalScale = .one }
        
        if let verb = verb(at: localPosition) {
            verb.scale = Vector2(value: 1.2)
        }
        
        return true
    }
    
    private func verb(at position:Vector2) -> Sprite2D?{
        (verbs.first { $0.rectInParent().hasPoint(position)})
    }
    
    private func doVerb(_ verb:Sprite2D){
        switch verb {
        case hack:  object?.onPhoned()
        case talk:  object?.onMouthed()
        case use:   object?.onUse()
        case look:  object?.onLookedAt()
        default: return
        }
    }
    
    private func makeLabel(){
        label.labelSettings = Label.settings()
        label.horizontalAlignment = .center
    }

}
