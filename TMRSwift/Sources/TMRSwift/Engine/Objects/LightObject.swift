import SwiftGodot

class LightObject : Object {
    
    let node = Circle2D()
    
    var radius:Float {
        (details.light?.radius ?? 100) * Float(Game.shared.scale)
    }
    
    var color:Color {
        Color(code: details?.light?.color ?? "#ffffff")
    }

    
    override func isTouched(at: Vector2) -> Bool { false }
    override var showItsHotspotHint: Bool { false }
    
    required override init(_ details: ObjectDetails? = nil) {
        super.init(details)
                            
        node.color = color
        node.modulate.alpha = Constants.debug ? 0.1 : 0.05
        node.radius = Double(radius)
        
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
    
    override func getNode() -> Node {
        node.position = position + (Vector2(value: radius) / 2)
        return node
    }
    
}
