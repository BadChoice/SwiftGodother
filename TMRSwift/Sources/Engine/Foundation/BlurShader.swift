import SwiftGodot

class BlurShader : Shader {
        
    public required init() {
        super.init()
        code =
        """
        shader_type canvas_item;
        
        uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
        uniform float blur_amount : hint_range(0, 5);
        
        void fragment() {
            COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
        }
        """
    }
    
    public required init(nativeHandle: UnsafeRawPointer){
        super.init(nativeHandle:nativeHandle)
        code =
        """
        shader_type canvas_item;
        
        uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
        uniform float blur_amount : hint_range(0, 5);
        
        void fragment() {
            COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
        }
        """
    }
}


class BlurShader2 : Shader {
        
    public required init() {
        super.init()
        code =
        """
        shader_type canvas_item;

        uniform float v = 1.0;
        uniform float size = 10.0;
        void fragment() {
            vec4 c = textureLod(TEXTURE, UV, 0.0);
            for (float x = -size; x < size; x++)
            {
                for (float y = -size; y < size; y++)
                {
                    if (x*x + y*y > size*size){continue;}
                    vec4 new_c = texture(TEXTURE, UV+TEXTURE_PIXEL_SIZE*vec2(x, y));
                    if (length(new_c) >length(c)){
                        c = new_c;
                    }
                }
            }
            COLOR = c;
            
        }
        """
    }
    
    public required init(nativeHandle: UnsafeRawPointer){
        super.init(nativeHandle:nativeHandle)
        code =
        """
        shader_type canvas_item;

        uniform float v = 1.0;
        uniform float size = 10.0;
        void fragment() {
            vec4 c = textureLod(TEXTURE, UV, 0.0);
            for (float x = -size; x < size; x++)
            {
                for (float y = -size; y < size; y++)
                {
                    if (x*x + y*y > size*size){continue;}
                    vec4 new_c = texture(TEXTURE, UV+TEXTURE_PIXEL_SIZE*vec2(x, y));
                    if (length(new_c) >length(c)){
                        c = new_c;
                    }
                }
            }
            COLOR = c;
            
        }
        """
    }
}
