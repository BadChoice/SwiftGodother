import SwiftGodot

class ChangeLanguageOption : MenuOption {
    var currentLanguage = 0
    
    init(){
        super.init(text: __(Constants.language))
        currentLanguage = Constants.languages.firstIndex(of: Constants.language)!
    }
    
    override func touchedAt(_ point: Vector2) -> Bool {
        if label.hasPoint(point){
            return perform()
        }
        return true
    }
    
    override func perform() -> Bool {
        currentLanguage  = (currentLanguage + 1) % Constants.languages.count
        let language     = Constants.languages[currentLanguage]
        label.text   = __(language)
        //UserDefaults.standard.setValue(language, forKey: "language")
        Constants.language = language
        return false
    }
}
