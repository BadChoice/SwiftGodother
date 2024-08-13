import Foundation

struct PlaySound : CompletableAction {
    
    let soundName:String
    let waitForCompletion:Bool
    
    init(_ soundName:String, waitForCompletion:Bool = false){
        self.soundName = soundName
        self.waitForCompletion = waitForCompletion
    }
    
    func run(then: @escaping () -> Void) {
        Sound.play(once: soundName, waitForCompletion: waitForCompletion) {
            then()
        }
    }
}
