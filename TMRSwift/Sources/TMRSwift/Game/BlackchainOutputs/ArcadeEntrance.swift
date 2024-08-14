import Foundation
import SwiftGodot

class ArcadeEntrance : Room {
    override var actorType:Actor.Type { Crypto.self }
    @StateWrapper("entered", object:ArcadeEntrance.self)
    static var entered:Bool
}

class VanFront : DecorationObject  {
    override var json: String { "ArcadeEntrance" }




}

class CarOil : SpriteObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "CarOil" }

    override var verbTexts: [Verbs : String] {[
        .talk : "Drink"
    ]}

}

class MultiUseKnife : SpriteObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "MultiUseKnife" }



}

class BowlingBall : SpriteObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "BowlingBall" }



}

class Balloon : SpriteObject , Inventoriable, Talks {
    override var json: String { "ArcadeEntrance" }
    var talkColor: Color      { "#ffffff" }
    @StateWrapper("painted", object:Balloon.self)
    static var painted:Bool

    @StateWrapper("poped", object:Balloon.self)
    static var poped:Bool


}

class Revisor : NonPlayableCharacter , Talks {
    override var json: String { "ArcadeEntrance" }
    var talkColor: Color      { "#ADC0CB" }



}

class MainteinanceGirl : NonPlayableCharacter , Talks {
    override var json: String { "ArcadeEntrance" }
    var talkColor: Color      { "#F0D8EF" }
    @StateWrapper("hasMatches", object:MainteinanceGirl.self)
    static var hasMatches:Bool


}

class ArcadeEntranceCoffeeCup : SpriteObject  {
    override var json: String { "ArcadeEntrance" }




}

class TicketsBox : SpriteObject  {
    override var json: String { "ArcadeEntrance" }

    @StateWrapper("stolen", object:TicketsBox.self)
    static var stolen:Bool


}

class TicketsCounterDisplay : DecorationObject  {
    override var json: String { "ArcadeEntrance" }




}

class Rabbit : SpriteObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "Rabbit" }
    @StateWrapper("hasBeenSwapped", object:Rabbit.self)
    static var hasBeenSwapped:Bool


}

class Minions : ShapeObject  {
    override var json: String { "ArcadeEntrance" }




}

class WinTickets : ShapeObject  {
    override var json: String { "ArcadeEntrance" }




}

class MoreThan18YearsSign : ShapeObject  {
    override var json: String { "ArcadeEntrance" }




}

class Lighter : ShapeObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "Lighter" }



}

class ArcadeNote : ShapeObject , Inventoriable {
    override var json: String { "ArcadeEntrance" }
    var inventoryImage: String { "ArcadeNote" }



}

class CountTicketsMachine : ShapeObject  {
    override var json: String { "ArcadeEntrance" }




}

class EntranceToArcadeDoor : ShapeObject, ChangesRoom {
    override var json: String { "ArcadeEntrance" }
}

