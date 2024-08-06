import Foundation
import SwiftGodot

class TexturePacker {
    
    let path:String
    let filename:String
    
    var textures:[Texture2D]?
    var info:TexturePackerStruct?

    struct TexturePackerSubimage: Decodable {
        let name:String
        let spriteOffset:String
        let spriteSourceSize:String
        var textureRect:String
        let textureRotated:Bool
        
        var region:Rect2 {
            var rectCopy = textureRect
            rectCopy.replace("{", with: "")
            rectCopy.replace("}", with: "")
            let components = rectCopy.components(separatedBy: ",").map { Float($0)! }
            return Rect2(position: Vector2(x:components[0], y:components[1]), size: Vector2(x:components[2], y:components[3]))
        }
        
        var offset:Vector2 {
            var rectCopy = spriteOffset
            rectCopy.replace("{", with: "")
            rectCopy.replace("}", with: "")
            let components = rectCopy.components(separatedBy: ",").map { Float($0)! }
            return Vector2(x: components[0], y: components[1])
        }
        
        var sourceSize:Vector2 {
            var rectCopy = spriteSourceSize
            rectCopy.replace("{", with: "")
            rectCopy.replace("}", with: "")
            let components = rectCopy.components(separatedBy: ",").map { Float($0)! }
            return Vector2(x: components[0], y: components[1])
        }
    }
    
    struct TexturePackerImage : Decodable {
        let path:String
        let size:String
        let subimages:[TexturePackerSubimage]
    }
    
    struct TexturePackerStruct : Decodable {
        var images:[TexturePackerImage]
    }
    
    init(path: String, filename:String){
        self.path = path
        self.filename = filename
    }
    
    
    func load() {
        info = loadInfo()
        textures = info?.images.compactMap {
            GD.load(path: path  + "/" + $0.path)
        }
    }
    
    func loadInfo() -> TexturePackerStruct? {
        let plist = FileAccess.getFileAsString(path: path + "/" + filename)
        do {
            var details = try PropertyListDecoder().decode(TexturePackerStruct.self, from: plist.data(using: .utf8)!)
            
            //Remove 2x version until we know how it works
            details.images = details.images.filter {
                Game.shared.scale == 1 ? !$0.path.contains("@2x") : $0.path.contains("@2x")
            }
            
            GD.print("[TexturePacker] loaded \(path) \(filename): \(details.images.count)")
            return details
        }catch{
            GD.printErr("[TexturePacker] Error loading plist \(path) \(filename): \(error)")
            return nil
        }
    }
    
    func textureNamed(name:String) -> Texture2D? {
        guard let textures, let info else { return nil }
        let nameWithoutFilename = name.withoutFilename()
        
        guard let subimageIndex = (info.images.firstIndex {
            $0.subimages.contains {
                return $0.name.withoutFilename().withoutScale() == nameWithoutFilename
            }
        }) else  {
            GD.printErr("[TexturePacker] Texture named \(nameWithoutFilename) not found")
            return nil
        }
        
        
        let texture = textures[subimageIndex]
        guard let imageInfo = (info.images[subimageIndex].subimages.first {
            $0.name.withoutFilename().withoutScale() == nameWithoutFilename }
        ) else {
            GD.printErr("[TexturePacker] Texture named \(nameWithoutFilename) not found")
            return nil
        }
        
        
        let atlas = AtlasTexture()
        atlas.atlas = texture
        atlas.region = imageInfo.region
        if imageInfo.textureRotated {
            let image = atlas.getImage()
            image?.rotate90(direction: .counterclockwise)
            return ImageTexture.createFromImage(image)
        }
        return atlas
    }
    
    func imageInfoFor(name:String) -> TexturePackerSubimage? {
        guard let textures, let info else { return nil }
        let nameWithoutFilename = name.withoutFilename()
        guard let subimageIndex = (info.images.firstIndex {
            $0.subimages.contains {
                return $0.name.withoutFilename().withoutScale() == nameWithoutFilename
            }
        }) else  {
            GD.printErr("[TexturePacker] Texture named \(nameWithoutFilename) not found")
            return nil
        }
        
        guard let imageInfo = (info.images[subimageIndex].subimages.first {
            $0.name.withoutFilename().withoutScale() == nameWithoutFilename }
        ) else {
            GD.printErr("[TexturePacker] Texture named \(nameWithoutFilename) not found")
            return nil
        }
        return imageInfo
    }
    
    func sprite(name:String) -> Sprite2D? {
        guard let texture = textureNamed(name: name) else { return nil }
        let sprite = Sprite2D(texture: texture)
        let info = imageInfoFor(name: name)!
        
        sprite.offset = (info.sourceSize * -1) + info.offset
        return sprite
    }
}
