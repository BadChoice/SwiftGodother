import SwiftGodot

class ChangeLanguageOption : Menu.Option {
    var currentLanguage = 0
    
    init(){
        super.init(text: __(Settings.language))
        currentLanguage = Constants.languages.firstIndex(of: Settings.language)!
    }
    
    override func perform(_ node:Node) -> Bool {
        changeLanguage()
        return false
    }
    
    override func touched(at point: Vector2) -> Bool {
        changeLanguage()
        return false
    }
    
    private func changeLanguage(){
        currentLanguage  = (currentLanguage + 1) % Constants.languages.count
        let language     = Constants.languages[currentLanguage]
        label.text   = __(language)
        //UserDefaults.standard.setValue(language, forKey: "language")
        Game.shared.translations = try? Translations.load(language: language)
        Settings.language = language
    }
}
