import SwiftGodot

class Hotspots {
    var node:Sprite2D!
    
    var hintsNode = Node2D()
    
    static var isBeingDisplayed = false
    
    init(){
        node = Sprite2D(path: "res://assets/ui/magnifier.png")
        node.zIndex = Constants.inventory_zIndex
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if node.hasPoint(position){
            show()
            return true
        }
        return false
    }
    
    
    func show() {
        guard !Self.isBeingDisplayed else { return }
        
        Self.isBeingDisplayed = true
        Game.shared.room.node.addChild(node: hintsNode)
        hintsNode.zIndex = Constants.inventory_zIndex
        hintsNode.modulate.alpha = 0
        
        Game.shared.room.objects.forEach {
            guard $0.showItsHotspotHint, $0.getNode()?.getParent() != nil else { return }
            let s = getHotspotSprite($0)
            s.position = $0.centerPoint()
            hintsNode.addChild(node: s)
        }
        
        hintsNode.run(.sequence([.repeatCount(.sequence([
            .fadeIn(withDuration: 0.6),
            .fadeAlpha(to: 0.5, duration: 0.6)
        ]), count:3),
           .fadeOut(withDuration: 0.6)
        ])) { [unowned self] in
            Self.isBeingDisplayed = false
            hintsNode.removeFromParent()
        }
    }
    
    private func getHotspotSprite(_ object:Object) -> Node2D {
        if let door = object as? ChangesRoom {
            return getArrow(door)
        }
        return getPoint()
    }
    
    private func getArrow(_ door:ChangesRoom) -> Sprite2D {
        let arrow = Sprite2D(path: "res://assets/ui/arrow.png")
        //arrow.zRotation = CGFloat(door.nextRoomArrowDirection.angle)
        return arrow
    }
    
    private func getPoint() -> Node2D {
        //let s = SKShapeNode(circleOfRadius: 12)
        let s = Circle2D()
        s.radius = 12 * Game.shared.scale
        s.modulate.alpha = 0.8
        s.color = .white
        
        //let s2 = SKShapeNode(circleOfRadius: 22)
        let s2 = Circle2D()
        s.radius = 22 * Game.shared.scale
        //s2.color = .clear
        //s2.strokeColor = .white
        //s2.lineWidth = 2
        s2.modulate.alpha = 0.2
        s.addChild(node: s2)
        return s
    }
 
    
    
    func reposition(room:Room){
        guard room.camera.enabled else { return }
        node.position = Vector2(
            x:room.camera.getScreenCenterPosition().x + (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y + (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: -120, y: -90) * Game.shared.scale
    }
}
