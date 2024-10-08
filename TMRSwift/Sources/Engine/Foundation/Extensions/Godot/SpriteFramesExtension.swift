import SwiftGodot

extension SpriteFrames {
    
    func createAnimation(name:String, prefix:String, frames:ClosedRange<Int>, atlas:TexturePacker, timePerFrame:Double, looped:Bool){
        addAnimation(anim: StringName(name))
        frames.forEach {
            let number = "\($0)".leftPadding(toLength: 2, withPad: "0")
            addFrame(anim: StringName(name), texture: atlas.textureNamed(prefix + number), duration:timePerFrame)
        }
        
        setAnimationLoop(anim: StringName(name), loop: looped)
    }
    
    func createSingleFrameAnimation(name:String, textureName:String, atlas:TexturePacker) {
        addAnimation(anim: StringName(name))
        addFrame(anim: StringName(name), texture: atlas.textureNamed(textureName))
        setAnimationLoop(anim: StringName(name), loop: false)
    }
}
