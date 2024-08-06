import SwiftGodot
import Foundation

class GDActionWait : GDAction {

    let duration:Double
    
    init(duration:Double){
        self.duration = duration
    }
    
    override func run(_ node:Node, completion:(()->Void)? = nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
}
