import SwiftGodot

class LightObject : Object {
    
    let node = Sprite2D()
    
    var radius:Float {
        (details.light?.radius ?? 100) * Float(Game.shared.scale)
    }
    
    var color:Color {
        Color(code: details?.light?.color ?? "#ffffff")
    }
    
    var intensity:Float {
        1
    }

    
    override func isTouched(at: Vector2) -> Bool { false }
    override var showItsHotspotHint: Bool { false }
    
    required override init(_ details: ObjectDetails? = nil) {
        super.init(details)
        
        if let texture:Texture2D = GD.load(path: "res://assets/lights/light_texture.png") {
            node.texture = texture
        }
        //node.energy = 1
        //node.blendMode = .add
        //node.color = color
        //node.radius = Double(radius)
        
        node.scale = Vector2(x:0.4, y:0.4)
        node.modulate = color
        
        // ---> This shader blurs everything behind! not what i want
        //let blurShader = BlurShader()
        //let material = ShaderMaterial()
        //material.setShaderParameter(param:"blur_amount", value: Variant(1))
        
        /*let blurShader = BlurShader2()
        let material = ShaderMaterial()
        material.setShaderParameter(param:"lod", value: Variant(1))
        
        material.shader = blurShader
        node.material = material*/
    }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        animate()
    }
    
    func animate(){
        node.run(.repeatForever(GDAction.sequence([
            GDAction.fadeAlpha(to: intensity * 0.1,  duration: Double.random(in:0.1...0.5)),
            GDAction.fadeAlpha(to: intensity * 0.22, duration: Double.random(in:0.1...0.5)),
            GDAction.fadeAlpha(to: intensity * 0.18, duration: Double.random(in:0.1...0.5)),
            GDAction.fadeAlpha(to: intensity * 0.25, duration: Double.random(in:0.1...0.5)),
            GDAction.fadeAlpha(to: intensity * 0.14, duration: Double.random(in:0.1...0.5)),
            GDAction.fadeAlpha(to: intensity * 0.12, duration: Double.random(in:0.1...0.5))
        ])))
    }
    
    override func getNode() -> Node {
        node.position = position + (Vector2(value: radius) / 2)
        return node
    }
    
}
