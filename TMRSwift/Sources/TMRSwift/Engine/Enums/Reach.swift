import Foundation

enum Reach : String, Codable {
    case normal
    case up
    case reallyUp
    case low
    
    var animation:String {
        switch self {
        case .normal :  "pickup"
        case .low :     "pickup-low"
        case .up :      "pickup-up"
        case .reallyUp: "pickup-really-up"
        }
    }
}
