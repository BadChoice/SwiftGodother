import Foundation

struct RemoveFromRoom : CompletableAction {
    
    let object:Object
    let paralelDelayMs:Int
    
    init(_ object:Object, paralelDelayMs:Int = 0){
        self.object = object
        self.paralelDelayMs = paralelDelayMs
    }
    
    func run(then: @escaping () -> Void) {
        
        let deadlineTime = DispatchTime.now() + .milliseconds(paralelDelayMs)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let roomObject = Game.shared.room.objects.first {
                $0.name == object.name
            }
            (roomObject as? SpriteObject)?.node?.removeFromParent()
            (roomObject as? ShapeObject)?.node.removeFromParent()
        }
        
        then()
    }

}
