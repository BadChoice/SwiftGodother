import SwiftGodot

extension Label {
    
    var position:Vector2 {
        getPosition()
    }
    
    static func settings(size:Int32 = Constants.fontSize, font:String = Constants.font) -> LabelSettings {
        let settings = LabelSettings()
        
        if let font:Font = GD.load(path: "res://assets/fonts/\(font)")  {
            settings.font = font
            settings.fontSize = size * Int32(Game.shared.scale)
            
            settings.outlineColor = .black
            settings.outlineSize = Constants.fontOutlineSize * Int32(Game.shared.scale)
            
            settings.shadowColor = .black
            settings.shadowSize = Constants.fontOutlineSize * Int32(Game.shared.scale)
            settings.shadowOffset = Vector2(value: 5 * Float(Game.shared.scale))
        }
        return settings
    }
    
    func hasPoint(_ point:Vector2) -> Bool {
        getRect().hasPoint(point)
    }
}
