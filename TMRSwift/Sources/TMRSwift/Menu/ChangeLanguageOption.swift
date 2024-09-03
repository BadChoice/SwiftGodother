import SwiftGodot

class ChangeLanguageOption : MenuOption {
    var currentLanguage = 0
    
    init(){
        super.init(text: __(Settings.language))
        currentLanguage = Constants.languages.firstIndex(of: Settings.language)!
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
        Game.shared.translations = try? Translations.load(language: language)
        Settings.language = language
        return false
    }
}
