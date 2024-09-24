import Foundation
import SwiftGodot

class TexturePacker {
    
    let path:String
    let filename:String
    
    var textures:[Texture2D]?
    var info:TexturePackerStruct?
    
    var debug:Bool = false

    struct TexturePackerSubimage: Decodable {
        let name:String
        let spriteOffset:String     // translation vector: the offset of the sprite's untrimmed center to the sprite's trimmed center
        //let spriteSize:String     // Size of the trimmed sprite
        let spriteSourceSize:String // Size of the untrimmed sprite
        let textureRect:String      // Sprite's position and size in the texture
        let textureRotated:Bool     // true if the sprite is rotated
        
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
    
    func textureNamed(_ name:String) -> Texture2D? {
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
        
        return extractTexture(info:imageInfo, texture:texture)
    }
    
    private func extractTexture(info:TexturePackerSubimage, texture:Texture2D) -> Texture2D? {
        let atlas = AtlasTexture()
        atlas.atlas = texture
        atlas.region = info.region
        
        let image = atlas.getImage()!
        
        if debug {
            GD.print(info)
        }
        
        if info.textureRotated {
            image.rotate90(direction: .counterclockwise)
        }
        
        
        let expandedImage = Image.create(
            width: Int32(info.sourceSize.x),
            height: Int32(info.sourceSize.y),
            useMipmaps: false,
            format: image.getFormat()
        )!
                
        let offset = Vector2i(
            x: Int32(info.offset.x),
            y: Int32(-info.offset.y)
        )
                
        let destination = Vector2i(
            x:0,
            y:expandedImage.getSize().y - image.getSize().y
        ) + offset
        
        expandedImage.blitRect(
            src: image,
            srcRect: Rect2i(position: .zero, size: image.getSize()),
            dst: destination //Texture packer places the image at bottom left, and then applies the offset
        )
        
        return ImageTexture.createFromImage(expandedImage)
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
        guard let texture = textureNamed(name) else { return nil }
        let sprite = Sprite2D(texture: texture)
        let info = imageInfoFor(name: name)!
        
        sprite.offset = (info.sourceSize * -1) + info.offset
        return sprite
    }
    
    
    func availableTextures() -> [String]{
        info?.images.flatMap { $0.subimages.flatMap { $0.name} } ?? []
    }
}


