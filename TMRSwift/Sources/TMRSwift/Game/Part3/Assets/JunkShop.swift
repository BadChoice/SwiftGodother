import Foundation
import SwiftGodot

class JunkShop : Room {
    //override var actorType:Actor.Type { Crypto.self }

}

/*class Axel : NonPlayableCharacter , Talks {
    override var json: String { "JunkShop" }
    var talkColor: Color      { "#C7B2A4" }
    @StateWrapper("toldAboutWalkies", object:Axel.self)
    static var toldAboutWalkies:Bool

    @StateWrapper("exchangedWalkieTalkies", object:Axel.self)
    static var exchangedWalkieTalkies:Bool

    @StateWrapper("toldAboutLostAndFound", object:Axel.self)
    static var toldAboutLostAndFound:Bool

    @StateWrapper("gotCube", object:Axel.self)
    static var gotCube:Bool

    @StateWrapper("toldAboutTv", object:Axel.self)
    static var toldAboutTv:Bool


}*/

class JunkFlag : SpriteObject  {
    override var json: String { "JunkShop" }




}

class JunkShopTv : SpriteObject  {
    override var json: String { "JunkShop" }

    @StateWrapper("isFixed", object:JunkShopTv.self)
    static var isFixed:Bool


}

/*class Cat : SpriteObject , Inventoriable, Talks {
    override var json: String { "JunkShop" }
    var inventoryImage: String { "Cat" }
    var talkColor: Color      { "#DC5821" }



}

class Larry : NonPlayableCharacter , Talks {
    override var json: String { "JunkShop" }
    var talkColor: Color      { "#89AACA" }



}*/

class GasTube : SpriteObject , Inventoriable {
    override var json: String { "JunkShop" }

    @StateWrapper("placedAtCave", object:GasTube.self)
    static var placedAtCave:Bool

    @StateWrapper("hasYouthWater", object:GasTube.self)
    static var hasYouthWater:Bool


}

class AncientCube : SpriteObject , Inventoriable {
    override var json: String { "JunkShop" }

    @StateWrapper("hasYouthWater", object:AncientCube.self)
    static var hasYouthWater:Bool

    @StateWrapper("hasZombiePart", object:AncientCube.self)
    static var hasZombiePart:Bool


}

class WalkieTalkies : SpriteObject , Inventoriable {
    override var json: String { "JunkShop" }

    @StateWrapper("placedAtMassage", object:WalkieTalkies.self)
    static var placedAtMassage:Bool

    @StateWrapper("placedAtPizza", object:WalkieTalkies.self)
    static var placedAtPizza:Bool


}

class ToyFan : ShapeObject , Inventoriable {
    override var json: String { "JunkShop" }
    var inventoryImage: String { "ToyFan" }
    @StateWrapper("installedToTdd", object:ToyFan.self)
    static var installedToTdd:Bool


}

class CyberCredits : ShapeObject , Inventoriable {
    override var json: String { "JunkShop" }
    var inventoryImage: String { "CyberCredits" }



}
/*
class Tires : ShapeObject  {
    override var json: String { "JunkShop" }




}

class JunkshopSpeaker : ShapeObject  {
    override var json: String { "JunkShop" }




}

class JunkBarrel : ShapeObject  {
    override var json: String { "JunkShop" }




}

class JunkClaw : ShapeObject  {
    override var json: String { "JunkShop" }




}

class JunkNote : ShapeObject  {
    override var json: String { "JunkShop" }




}

class LostAndFoundSign : ShapeObject  {
    override var json: String { "JunkShop" }




}

class Junkbox : ShapeObject  {
    override var json: String { "JunkShop" }




}

class JunkNoteSmall : ShapeObject  {
    override var json: String { "JunkShop" }




}
*/
class TvAntenna : PolygonShapedObject  {
    override var json: String { "JunkShop" }




}
/*
class JunkShopToPortal : ShapeObject, ChangesRoom {
    override var json: String { "JunkShop" }
}

class JunkShopLight0 : LightObject {
    override var json: String { "JunkShop" }
}*/
