import Foundation
import SwiftGodot

class SupremeHackerBasement : Room {
    override var actorType:Actor.Type { Crypto.self }
    @StateWrapper("entered", object:SupremeHackerBasement.self)
    static var entered:Bool
}

class BasementCoffeeCup : SpriteObject  {
    override var json: String { "SupremeHackerBasement" }




}

class SupremeHacker : NonPlayableCharacter , Talks {
    override var json: String { "SupremeHackerBasement" }
    var talkColor: Color      { "#B0A7A6" }



}

class WhiteBallsBox : ShapeObject  {
    override var json: String { "SupremeHackerBasement" }




}

class Oculus : ShapeObject  {
    override var json: String { "SupremeHackerBasement" }




}

class PillBag : ShapeObject , Inventoriable {
    override var json: String { "SupremeHackerBasement" }

    @StateWrapper("isSmashed", object:PillBag.self)
    static var isSmashed:Bool

    @StateWrapper("hasIce", object:PillBag.self)
    static var hasIce:Bool

    @StateWrapper("hasRabbit", object:PillBag.self)
    static var hasRabbit:Bool

    @StateWrapper("hasLube", object:PillBag.self)
    static var hasLube:Bool


}

class Tank1 : ShapeObject  {
    override var json: String { "SupremeHackerBasement" }




}

class Tank2 : ShapeObject  {
    override var json: String { "SupremeHackerBasement" }




}

class SupremeHackerScreen : ShapeObject  {
    override var json: String { "SupremeHackerBasement" }




}

class BasementToArcadeDoor : ShapeObject, ChangesRoom {
    override var json: String { "SupremeHackerBasement" }
}

class SupremeHackerBasementLight0 : LightObject {
    override var json: String { "SupremeHackerBasement" }
}
