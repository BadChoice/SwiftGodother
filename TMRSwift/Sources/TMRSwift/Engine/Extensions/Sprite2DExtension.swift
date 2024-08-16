import SwiftGodot

extension Sprite2D {
    
    convenience init(texture:Texture2D) {
        self.init()
        self.texture = texture
    }
    
    convenience init(path:String) {
        
        var finalPath = path
        if Game.shared.scale == 2 {
            finalPath = finalPath.appendBeforeExtension("@2x")
        }
        
        GD.print("Loading with path \(finalPath)", Game.shared.scale)
        
        if let texture:Texture2D = GD.load(path: finalPath) {
            self.init(texture: texture)
        }else{
            self.init()
        }
    }
    
    func hasPoint(_ point:Vector2) -> Bool {
        rectInParent().hasPoint(point)
    }
    
    func rectInParent() ->  Rect2 {
        (transform * getRect())
    }
    
    func set(texture name:String) {
        texture = Game.shared.room.atlas.textureNamed(name: name)
    }
    
    func animateForever(_ textures:[Texture2D], timePerFrame:Double){
        run(.animateForever(textures, timePerFrame: timePerFrame))
    }
    
}
