import Foundation

typealias Wait = Delay

struct Delay : CompletableAction {
    
    let ms:Int
    
    init(ms:Int){
        self.ms = ms
    }
    
    func run(then: @escaping () -> Void) {
        let deadlineTime = DispatchTime.now() + .milliseconds(ms)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            then()
        }
    }
}
