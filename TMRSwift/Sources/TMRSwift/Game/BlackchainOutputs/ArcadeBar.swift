import Foundation
import SwiftGodot

class ArcadeBar : Room {
    override var actorType:Actor.Type { Crypto.self }

}

class BowlingScreen : SpriteObject  {
    override var json: String { "ArcadeBar" }




}

class BarTable : DecorationObject  {
    override var json: String { "ArcadeBar" }




}

class Toothpicks : SpriteObject , Inventoriable {
    override var json: String { "ArcadeBar" }

    @StateWrapper("wet", object:Toothpicks.self)
    static var wet:Bool

    @StateWrapper("hasFertilizer", object:Toothpicks.self)
    static var hasFertilizer:Bool

    @StateWrapper("areMatches", object:Toothpicks.self)
    static var areMatches:Bool
    override var verbTexts: [Verbs : String] {[
        .talk : "Lick"
    ]}

}

class Barman : NonPlayableCharacter , Talks {
    override var json: String { "ArcadeBar" }
    var talkColor: Color      { "#E5E4E2" }
    @StateWrapper("madeTheCocktail", object:Barman.self)
    static var madeTheCocktail:Bool


}

class Pirate : NonPlayableCharacter , Talks {
    override var json: String { "ArcadeBar" }
    var talkColor: Color      { "#999795" }



}

class BowlingTickets : SpriteObject  {
    override var json: String { "ArcadeBar" }




}

class ArcadeMachineButton : ShapeObject  {
    override var json: String { "ArcadeBar" }

    @StateWrapper("pushed", object:ArcadeMachineButton.self)
    static var pushed:Bool
    override var verbTexts: [Verbs : String] {[
        .use : "Push"
    ]}

}

class Coin : ShapeObject , Inventoriable {
    override var json: String { "ArcadeBar" }
    var inventoryImage: String { "Coin" }
    @StateWrapper("used", object:Coin.self)
    static var used:Bool
    override var verbTexts: [Verbs : String] {[
        .talk : "Bite"
    ]}

}

class ReuseCoffeeCupsPromo : ShapeObject  {
    override var json: String { "ArcadeBar" }

    @StateWrapper("isRead", object:ReuseCoffeeCupsPromo.self)
    static var isRead:Bool


}

class RevoIpad : ShapeObject  {
    override var json: String { "ArcadeBar" }




}

class PlayAloneSign : ShapeObject  {
    override var json: String { "ArcadeBar" }




}

class OutOfOrderSign : ShapeObject  {
    override var json: String { "ArcadeBar" }




}

class CoffeeCup : ShapeObject , Inventoriable {
    override var json: String { "ArcadeBar" }

    @StateWrapper("gotBarOne", object:CoffeeCup.self)
    static var gotBarOne:Bool

    @StateWrapper("gotHiddenOne", object:CoffeeCup.self)
    static var gotHiddenOne:Bool

    @StateWrapper("gotBasementOne", object:CoffeeCup.self)
    static var gotBasementOne:Bool

    @StateWrapper("gotEnentranceOne", object:CoffeeCup.self)
    static var gotEnentranceOne:Bool


}

class Ice : ShapeObject , Inventoriable {
    override var json: String { "ArcadeBar" }
    var inventoryImage: String { "Ice" }
    @StateWrapper("isSmashed", object:Ice.self)
    static var isSmashed:Bool


}

class Cocktail : ShapeObject , Inventoriable {
    override var json: String { "ArcadeBar" }




}

class BarToArcadeDoor : ShapeObject, ChangesRoom {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight0 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight1 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight2 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight3 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight4 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight5 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight6 : LightObject {
    override var json: String { "ArcadeBar" }
}

class ArcadeBarLight7 : LightObject {
    override var json: String { "ArcadeBar" }
}
