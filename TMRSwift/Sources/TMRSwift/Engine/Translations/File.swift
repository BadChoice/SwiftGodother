import Foundation
import SwiftGodot

struct Translations {
    
    let texts:[String:String]
    
    static func load(path:String) throws -> Translations {
        let file = FileAccess.getFileAsString(path: path)
        let texts = try PropertyListDecoder().decode([String:String].self, from: file.data(using: .utf8)!)
        
        return Translations(texts: texts)
    }
    
    func translated(_ key:String) -> String {
        texts[key] ?? key
    }
    
}
