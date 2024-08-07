import SwiftGodot

class Cache {
    
    static var shared:Cache = Cache()
    
    var cached:[String:Any] = [:]
    
    func cache<T>(key:String, _ block:()->T) -> T {
        if let value = cached[key] as? T {
            return value
        }
        
        if key == "roomDetails-" {
            print("WHAT?")
        }
        
        print("[Cache] Miss for \(key)")
        let value = block()
        cached[key] = value
        return value
        
    }
    
    func clear(){
        cached.removeAll()
    }
    
}
