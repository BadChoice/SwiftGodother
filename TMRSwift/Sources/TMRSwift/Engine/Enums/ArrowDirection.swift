enum ArrowDirection : String, Codable {
    case up, right, down, left
    
    var angle:Double {
        switch self {
        case .up   : 0
        case .right: 1.57079633
        case .left : -1.57079633
        case .down : 3.14159265
        }
    }
}
