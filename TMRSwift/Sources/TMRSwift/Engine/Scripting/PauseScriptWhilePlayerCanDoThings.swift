import Foundation

class PauseScriptWhilePlayerCanDoThings : CompletableAction {

    let ms:Int
    
    init(ms:Int){
        self.ms = ms
    }
    
    func run(then: @escaping () -> Void) {
        Game.shared.touchLocked = false
        let deadlineTime = DispatchTime.now() + .milliseconds(ms)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.onTimePassed(then: then)
        }
    }
    
    func onTimePassed(then: @escaping () -> Void){
        /*if inventory.isShowing || RevisorYack.isStealingTickets || DorkYack.isCertificateBeingStolen {
            return DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(2000)) {
                self.onTimePassed(then: then)
            }
        }*/
        Game.shared.touchLocked = true
        then()
    }
}
