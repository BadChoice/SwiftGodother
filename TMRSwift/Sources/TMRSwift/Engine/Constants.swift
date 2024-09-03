import SwiftGodot

struct Constants {
    
    static var debug:Bool = true
    
    //MARK: - Room
    static let background_zIndex:Int32  = -1
    static let foreground_zIndex:Int32  = 100
    static let inventory_zIndex:Int32   = 200
    static let scanner_zIndex:Int32     = 250
    static let verbwheel_zIndex:Int32   = 251
    static let talk_zIndex:Int32        = 300
    static let menu_zIndex:Int32        = 310
    static let cursor_zIndex:Int32      = 400
    
    //MARK: - WALK
    static var walkSpeed:Float       = 800
    static var fastWalkFactor:Float  = 2.5
    
    static var longPressMinTime = 0.3
    
    //MARK: - SOUND
    static var musicVolume:Float     = 0.4
    static var ambienceVolume:Float  = 0.8
    static var sfxVolume:Float       = 1.0
    
    
    //MARK: - TALK
    static let languages             = ["en", "es", "de", /*"fr", */"ca"]
    static var fontSize:Int32        = /*isPhone ? 50 : */40
    static var fontOutlineSize:Int32 = /*isPhone ? 50 : */18
    static var wordTime              = 0.4
    static var charTime              = 0.07
    static var useWordTiming         = false
    static var lineWordLength:Int    { Settings.language == "de" ? 7 : 9 }
    static var yackSpacing:Float     = /*isPhone ? 80 : */60
    static var fingerOffset:Float    = /*isPhone ? 80 : */80
    static var fontName:String       = "Janda Manatee Solid"
    static var font:String           = "JandaManateeSolid.ttf"
    static var talkBackgroundAlpha:Float  = 0.8
    static var guyTalkColor:Color   = "#EDEB67"

}

struct Features {
    //static var useCanBeUsedWith = (UserDefaults.standard.object(forKey: "hardMode") as AnyObject?)?.boolValue ?? true
    static var useCanBeUsedWith = true
    static var doubleDoorClickChangesRoom = true
    static var showVerbWheelActionNames = false
}
