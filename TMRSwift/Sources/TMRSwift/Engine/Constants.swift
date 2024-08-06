import SwiftGodot

struct Constants {
    
    static var debug:Bool = true
    
    //MARK: - RoOM
    static let background_zIndex:Int32  = -1
    static let foreground_zIndex:Int32  = 100
    static let scanner_zIndex:Int32     = 200
    static let inventory_zIndex:Int32   = 201
    static let verbwheel_zIndex:Int32   = 202
    static let talk_zIndex:Int32        = 300
    
    //MARK: - WALK
    static var walkSpeed:Float       = 800
    static var fastWalkFactor:Float  = 2.5
    
    
    static var longPressMinTime = 0.5
    
    //MARK: - SOUND
    static var musicVolume:Float     = 0.4
    static var ambienceVolume:Float  = 0.8
    static var sfxVolume:Float       = 1.0
    
    
    //MARK: - TALK
    static var language:String      = "en"
    static let languages = ["en", "es", "de", /*"fr", */"ca"]
    static var fontSize:Int         = /*isPhone ? 50 : */40
    static var wordTime             = 0.4
    static var charTime             = 0.07
    static var useWordTiming        = false
    static var lineWordLength:Int   { Constants.language == "de" ? 7 : 9 }
    static var yackSpacing          = /*isPhone ? 80 : */60
    static var fingerOffset         = /*isPhone ? 80 : */40
    static var fontName:String      = "Janda Manatee Solid"
    static var talkBackgroundAlpha:Float  = 0.6
    //static var guyTalkColor:Color  = "#EDEB67"

}
