import Foundation
import SwiftGodot

struct ScreenScanner : HandlesDrag {
    
    let label:Label
    
    init(){
        label = Label()
        
        if let font:Font = GD.load(path: "res://assets/fonts/UglyQua.ttf")  {
            let settings = LabelSettings()
            settings.font = font
            settings.fontSize = 50
            settings.outlineColor = .black
            settings.outlineSize = 6
            label.horizontalAlignment = .center
            label.labelSettings = settings
            label.text = ""
            label.zIndex = Constants.scanner_zIndex
        }
    }
    
    func onMouseMoved(room:Room, at position:Vector2) -> Bool {
        if let object = (room.objects.first {
            $0.isTouched(at: position)
        }) {
            label.show()
            show(object: object, at: position)
        } else {
            label.hide()
        }
        
        return false
    }
    
    func show(object:Object, at position:Vector2){
        label.setPosition(position - (label.getSize() * 0.5) - Vector2(x: 0, y: 60))
        label.text = object.details.name
    }
}
