import Foundation
import SwiftGodot

class TextSpeedOption : Menu.Option {
 
    var currentSpeed = "normal"
    var repeatOption = 1
    
    var speeds : [String:Double] = [
        "slow"   : 0.12,
        "normal" : 0.07,
        "fast"   : 0.05
    ]
    
    init() {
        super.init(text: __("Text Speed") + ": " + __("normal"))
        let current = speeds.first { key, value in
            value == Constants.charTime
        }
        currentSpeed = current?.key ?? "normal"
        let index = Array(speeds.keys).firstIndex(of: currentSpeed)
        repeatOption = index ?? 1
        text = __("Text Speed") + ": " + __(currentSpeed).capitalized
    }    
    
    override func perform(_ node:Node) -> Bool {
        changeSpeed()
        return false
    }
    
    override func touched(at point:Vector2) -> Bool {
        if label.hasPoint(point){
            changeSpeed()
            return false
        }
        return true
    }

    private func changeSpeed(){
        repeatOption = (repeatOption + 1) % speeds.count

        let key = Array(speeds.keys)[repeatOption]

        Constants.charTime = speeds[key]!
        changeText(key)        
    }
    
    func changeText(_ speed:String){
        label.text = __("Text Speed") + ": " + __(speed).capitalized
    }
}
