enum ArrowDirection : String, Codable {
    case up, right, down, left
    
    var angle:Double {
        switch self {
        case .up:    return 0
        case .right : return -1.57079633
        case .left : return 1.57079633
        case .down : return 3.14159265
        }
    }
}
