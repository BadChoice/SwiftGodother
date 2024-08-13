import SwiftGodot

class DeviceVibration {

    static func light(){
        Input.vibrateHandheld(durationMs:200)
    }
    
    static func medium(){
        Input.vibrateHandheld(durationMs:500)
    }
    
    static func strong(){
        Input.vibrateHandheld(durationMs:800)
    }

    
}
