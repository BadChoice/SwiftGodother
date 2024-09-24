import Foundation

class Autosave : CompletableAction {

    func run(then: @escaping () -> Void) {
        let game = SaveGame()
        //iCloudStorage.upload(game, slot: 0)
        UserStorage.make().upload(game, slot: 0)
        then()
    }
}
