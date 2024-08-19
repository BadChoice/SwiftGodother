import SwiftGodot

class MenuOption {
    let label = Label()

    var text:String
    
    init(text:String){
        self.text = text
        label.labelSettings = Label.settings()
        label.horizontalAlignment = .right
        label.text = text
    }
    
    func perform() -> Bool{
        false
    }
    
    func touchedAt(_ point:Vector2) -> Bool {
        true
    }
}
