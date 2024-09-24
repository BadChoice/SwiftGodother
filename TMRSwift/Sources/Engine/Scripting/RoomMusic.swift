import Foundation

class PauseRoomMusic : CompletableAction {
    
    let onlyFx:Bool
    init(onlyFx:Bool = false){
        self.onlyFx = onlyFx
    }
    
    func run(then: @escaping () -> Void) {
        Game.shared.room.stopMusic(onlyFx: onlyFx)
        then()
    }
}

class ResumeRoomMusic : CompletableAction {
    
    let onlyFx:Bool
    init(onlyFx:Bool = false){
        self.onlyFx = onlyFx
    }
    
    func run(then: @escaping () -> Void) {
        Game.shared.room.playMusic(onlyFx: onlyFx)
        then()
    }
}
