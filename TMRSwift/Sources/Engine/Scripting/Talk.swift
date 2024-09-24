import Foundation

struct Talk : CompletableAction {
    
    let yack:Yack
    
    func run(then:@escaping ()->Void) {
        yack.scene = Game.shared.scene
        Game.shared.currentYack = yack
        yack.run {
            Game.shared.currentYack = nil
            then()
        }
    }
}
