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
    }
    
    func onMouseMoved(at position:Vector2, object:Object?) -> Bool {
        show(object: object, at: position)
        return false
    }
    
    func show(object:Object?, at position:Vector2){
        show(text: object?.name ?? "" , at:position)
    }
    
    func show(text:String, at position:Vector2){
        label.modulate.alpha = 1
        label.text = text
        label.setPosition(position - (label.getSize() * 0.5) - Vector2(x: 0, y: 60) * Game.shared.scale)
    }
    
    /*func stop(){
        label.modulate.alpha = 0
    }*/
}
