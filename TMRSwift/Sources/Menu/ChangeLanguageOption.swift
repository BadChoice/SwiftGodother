import SwiftGodot

class ChangeLanguageOption : Menu.Option {
    var currentLanguage = 0
    
    init(){
        super.init(text: __(Settings.shared.language))
        currentLanguage = Constants.languages.firstIndex(of: Settings.shared.language)!
    }
    
    override func perform(_ node:Node) -> Bool {
        changeLanguage()
        return false
    }
    
    override func touched(at point: Vector2) -> Bool {
        if label.hasPoint(point){
            changeLanguage()
            return false
        }
        return true
    }
    
    private func changeLanguage(){
        currentLanguage  = (currentLanguage + 1) % Constants.languages.count
        let language     = Constants.languages[currentLanguage]
        label.text   = __(language)
        Game.shared.translations = try? Translations.load(language: language)
        Settings.shared.language = language
        Settings.shared.save()
    }
}
