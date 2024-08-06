import Foundation
import SwiftGodot

struct ScreenScanner {
    
    let label:Label
    
    init(){
        label = Label()
        
        if let font:Font = GD.load(path: "res://assets/fonts/\(Constants.font)" )  {
            let settings = LabelSettings()
            settings.font = font
            settings.fontSize = Constants.fontSize * Int32(Game.shared.scale)
            settings.outlineColor = .black
            settings.outlineSize = Constants.fontOutlineSize * Int32(Game.shared.scale)
            label.horizontalAlignment = .center
            label.labelSettings = settings
            label.text = ""
            label.zIndex = Constants.scanner_zIndex
        }
    }
    
    func onMouseMoved(at position:Vector2, object:Object?) -> Bool {
        if let object {
            label.show()
            show(object: object, at: position)
        } else {
            label.hide()
        }
        
        return false
    }
    
    func show(object:Object, at position:Vector2){
        label.modulate.alpha = 1
        label.setPosition(position - (label.getSize() * 0.5) - Vector2(x: 0, y: 60) * Game.shared.scale)
        label.text = object.name
    }
    
    func stop(){
        label.modulate.alpha = 0
    }
}
