import Foundation

enum Footsteps : String, Codable {
    case concrete
    case wood
    case grass
    case metal
    case water
    case cave
    case map
    
    func filename() -> String {
        //"sfx/footsteps_\(self).mp3"
        "sfx/footsteps.mp3"
    }
}
