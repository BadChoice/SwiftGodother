import Foundation

struct ReloadSprite : CompletableAction {
    
    let object:SpriteObject
    
    init(_ object:SpriteObject){
        self.object = object
    }
        
    func run(then: @escaping () -> Void) {
        guard let atlas      = Game.shared.room.atlas else {
            return then()
        }
        object.node?.texture = atlas.textureNamed(object.image)
        then()
    }
}
