import SwiftGodot

extension Menu {
    class Option {
        let label = Label()
        
        var text:String
        
        init(text:String){
            self.text = text
            label.labelSettings = Label.settings()
            label.horizontalAlignment = .right
            label.growHorizontal = .begin
            label.text = text
        }
        
        func perform(_ node:Node) -> Bool{
            false
        }
        
        func touched(at point:Vector2) -> Bool {
            true
        }
    }
}
