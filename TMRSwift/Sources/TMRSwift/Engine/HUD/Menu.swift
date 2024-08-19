import SwiftGodot

class Menu {
    let icon:Sprite2D!
    let node = Node()
    let background = ColorRect()
    
    var isShowing:Bool = false
    
    init(){
        
        icon = Sprite2D(path: "res://assets/ui/settings.png")
        
        node.addChild(node: icon)
        icon.zIndex = Constants.menu_zIndex
    }
    
    func onTouched(at position:Vector2) -> Bool {
        if isShowing {
            hide()
            return true
        }
        if icon.hasPoint(position){
            show()
            return true
        }
        return false
    }
    
    func show(){
        Sound.play(once: "tutorial_appear")
        isShowing = true
        
        background.setSize(Vector2(x:500, y:500))
        background.zIndex = Constants.menu_zIndex + 1
        background.color = .black
        
        background.setSize(Game.shared.room.camera.getViewportRect().size * 2)
        background.setPosition(Game.shared.room.camera.getViewportRect().size * -1 + Game.shared.room.camera.getScreenCenterPosition())
        
        background.modulate.alpha = 0
        node.addChild(node: background)
        background.run(
            .fadeAlpha(to: 0.8, duration: 0.2)
        )
    }
    
    func hide(){
        isShowing = false
        
        background.run(
            .fadeAlpha(to: 0, duration: 0.2)
        ){ [weak self] in
            self?.background.removeFromParent()
        }
    }
    
    func reposition(room:Room){
        guard room.camera.enabled else { return }
        icon.position = Vector2(
            x:room.camera.getScreenCenterPosition().x + (room.camera.getViewportRect().size.x / 2),
            y:room.camera.getScreenCenterPosition().y - (room.camera.getViewportRect().size.y / 2)
        ) + Vector2(x: -90, y: 70) * Game.shared.scale
    }
}
