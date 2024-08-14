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
        node.modulate.alpha = Constants.debug ? 0.3 : 0.0
        node.radius = Double(radius)
        
        // ---> This shader blurs everything behind! not what i want
        let blurShader = Shader()
        blurShader.code = """
        shader_type canvas_item;
        
        uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
        uniform float blur_amount : hint_range(0, 5);

        void fragment() {
            COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
        }
        """
        
        let material = ShaderMaterial()
        material.setShaderParameter(param:"blur_amount", value: Variant(1))
        
        material.shader = blurShader
        node.material = material
        
        
        
    }
    
    override func getNode() -> Node {
        node.position = position + (Vector2(value: radius) / 2)
        return node
    }
    
}
