import Foundation

extension String {    
    func leftPadding(toLength: Int, withPad character: Character) -> String {
      if count < toLength {
        return String(repeating: character, count: toLength - count) + self
      } else {
        return self
      }
    }    
    
    func withoutFilename() -> String {
        if !contains(".") { return self }
        return split(separator: ".").dropLast().joined(separator: ".")
    }
    
    func withoutScale() -> String {
        var copy = self
        copy.replace("@2x", with:"")
        return copy
    }
    
    func appendBeforeExtension(_ string:String) -> String {
        if !contains(".") { return self + string }
        let components = split(separator: ".")
        let path = components.dropLast()
        let ext = components.last ?? ""
        
        return path.joined(separator: ".") + string + "." + ext
    }
}
