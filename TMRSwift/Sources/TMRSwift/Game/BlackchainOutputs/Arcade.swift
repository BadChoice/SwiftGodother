import Foundation
import SwiftGodot

class Arcade : Room {
    override var actorType:Actor.Type { Crypto.self }
    @StateWrapper("entered", object:Arcade.self)
    static var entered:Bool
}

class SmashHammer : SpriteObject , Inventoriable {
    override var json: String { "Arcade" }
    var inventoryImage: String { "SmashHammer" }



}

class PunchBag : SpriteObject , Inventoriable {
    override var json: String { "Arcade" }

    @StateWrapper("isCut", object:PunchBag.self)
    static var isCut:Bool

    @StateWrapper("hasGoldenBall", object:PunchBag.self)
    static var hasGoldenBall:Bool
    override var verbTexts: [Verbs : String] {[
        .use : "Punch"
    ]}

}

class TrapDoor : SpriteObject  {
    override var json: String { "Arcade" }


    override var verbTexts: [Verbs : String] {[
        .use : "Open"
    ]}

}

class HiddenCoffeeCup : SpriteObject , Inventoriable {
    override var json: String { "Arcade" }
    var inventoryImage: String { "HiddenCoffeeCup" }
    @StateWrapper("triedSomething", object:HiddenCoffeeCup.self)
    static var triedSomething:Bool


}

class ToyArrow : SpriteObject , Inventoriable {
    override var json: String { "Arcade" }

    @StateWrapper("isCutGlass", object:ToyArrow.self)
    static var isCutGlass:Bool


}

class DragonTooth : SpriteObject , Inventoriable {
    override var json: String { "Arcade" }
    var inventoryImage: String { "DragonTooth" }



}

class Figther00 : SpriteObject  {
    override var json: String { "Arcade" }




}

class Smash00 : SpriteObject  {
    override var json: String { "Arcade" }




}

class Tinyshooter00 : SpriteObject  {
    override var json: String { "Arcade" }




}

class ArcadeTickets : SpriteObject  {
    override var json: String { "Arcade" }




}

class MaxKid : NonPlayableCharacter , Talks {
    override var json: String { "Arcade" }
    var talkColor: Color      { "#646F5A" }

    override var verbTexts: [Verbs : String] {[
        .talk : "Talk"
    ]}

}

class ArcadePlant : ShapeObject  {
    override var json: String { "Arcade" }




}

class Sand : ShapeObject , Inventoriable {
    override var json: String { "Arcade" }

    @StateWrapper("isMud", object:Sand.self)
    static var isMud:Bool

    @StateWrapper("isRabbit", object:Sand.self)
    static var isRabbit:Bool

    @StateWrapper("isWhiteRabbit", object:Sand.self)
    static var isWhiteRabbit:Bool


}

class TinyHeroArcade : ShapeObject , Talks {
    override var json: String { "Arcade" }
    var talkColor: Color      { "#A3BAC4" }
    @StateWrapper("played", object:TinyHeroArcade.self)
    static var played:Bool


}

class EarnedTickets : ShapeObject , Inventoriable {
    override var json: String { "Arcade" }

    @StateWrapper("gotBowlingOnes", object:EarnedTickets.self)
    static var gotBowlingOnes:Bool

    @StateWrapper("gotTinyShooterOnes", object:EarnedTickets.self)
    static var gotTinyShooterOnes:Bool

    @StateWrapper("gotTicketBoxOnes", object:EarnedTickets.self)
    static var gotTicketBoxOnes:Bool


}

class NoLightersSign : ShapeObject  {
    override var json: String { "Arcade" }

    @StateWrapper("read", object:NoLightersSign.self)
    static var read:Bool


}

class ChangeMachine : ShapeObject  {
    override var json: String { "Arcade" }




}

class PunchMachine : PolygonShapedObject  {
    override var json: String { "Arcade" }

    @StateWrapper("hasGoldenPunchBag", object:PunchMachine.self)
    static var hasGoldenPunchBag:Bool


}

class ArcadeToEntranceDoor : ShapeObject, ChangesRoom {
    override var json: String { "Arcade" }
}

class ArcadeToBarDoor : ShapeObject, ChangesRoom {
    override var json: String { "Arcade" }
}

class ArcadeToBasementDoor : ShapeObject, ChangesRoom {
    override var json: String { "Arcade" }
}

class ArcadeLight0 : LightObject {
    override var json: String { "Arcade" }
}

class ArcadeLight1 : LightObject {
    override var json: String { "Arcade" }
}

class ArcadeLight2 : LightObject {
    override var json: String { "Arcade" }
}

class ArcadeLight3 : LightObject {
    override var json: String { "Arcade" }
}

class ArcadeLight4 : LightObject {
    override var json: String { "Arcade" }
}

class ArcadeLight5 : LightObject {
    override var json: String { "Arcade" }
}
