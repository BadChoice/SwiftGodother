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
        
        GD.print("[Sprite2D] Loading with path \(finalPath)", Game.shared.scale)
        
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
        texture = Game.shared.room.atlas.textureNamed(name)
    }
    
    func set(texture texture:Texture2D?) {
        guard let texture else { return }
        self.texture = texture
    }
    
    func show(withTexture:Texture2D?){
        show()
        if let withTexture {
            texture = withTexture
        }
    }
    
    func animateForever(_ textures:[Texture2D], timePerFrame:Double){
        run(.animateForever(textures, timePerFrame: timePerFrame))
    }
    
    func animateForever(_ names:[String], timePerFrame:Double){
        run(.animateForever(textures(names), timePerFrame: timePerFrame))
    }
    
    func animate(_ textures:[Texture2D], timePerFrame:Double){
        run(.animate(textures, timePerFrame: timePerFrame))
    }
    
}
