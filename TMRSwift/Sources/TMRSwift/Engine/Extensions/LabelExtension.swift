import SwiftGodot

extension Label {
    
    var position:Vector2 {
        set { setPosition(position) }
        get { getPosition() }
    }
    
    static func settings() -> LabelSettings {
        let settings = LabelSettings()
        
        if let font:Font = GD.load(path: "res://assets/fonts/\(Constants.font)")  {
            settings.font = font
            settings.fontSize = Constants.fontSize * Int32(Game.shared.scale)
            
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
