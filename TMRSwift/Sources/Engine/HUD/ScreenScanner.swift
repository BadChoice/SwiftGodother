import Foundation
import SwiftGodot

struct ScreenScanner {
    
    let label:Label
    
    init(){
        label = Label()
        label.horizontalAlignment = .center
        label.labelSettings = Label.settings()
        label.text = ""
        label.zIndex = Constants.scanner_zIndex
        label.growVertical = .both
        label.growHorizontal = .both
    }
    
    func onMouseMoved(at point:Vector2, object:Object?) -> Bool {
        Game.shared.scene.cursor.hideArrow()
        guard let object else {
            show(text: "", at: point)
            return false
        }
        if let door = object as? ChangesRoom {
            show(arrow: door, at: point)
            return false
        }
        show(object: object, at: point)
        return false
    }
    
    func show(object:Object?, at point:Vector2){
        show(text: __(object?.name ?? "") , at:point)
    }
    
    func show(arrow:ChangesRoom, at point:Vector2){
        Game.shared.scene.cursor.showArrow(arrow.nextRoomArrowDirection.angle)
        show(text:"", at:point)
    }
    
    func show(text:String, at point:Vector2){
        label.modulate.alpha = 1
        label.text = text
        label.setPosition(
            Game.shared.safePosition(
                point - Vector2(x: 0, y: Constants.fingerOffset) * Game.shared.scale,
                size: label.getSize()) - label.getSize() * 0.5
            )
    }
    
    
    /*func stop(){
        label.modulate.alpha = 0
    }*/
}
