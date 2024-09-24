import Foundation

enum Verbs : String, Codable {
    case use    = "use"
    case talk   = "talk"
    case look   = "look"
    case hack   = "hack"
    
    var performText : String {
        switch self {
        case .use   : "Use"
        case .talk  : "Lick"
        case .look  : "Look at"
        case .hack  : "Hack"
        }
    }
}
