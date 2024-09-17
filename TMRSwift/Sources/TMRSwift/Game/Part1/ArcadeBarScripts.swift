import Foundation
import SwiftGodot

class ArcadeBarScripts : RoomScripts {
    
    override func onEnter() {
        //node.addChild(Rain.make())
        scriptedRoom.node.run(.scale(to: 1.02, duration:1).withTimingMode(.out))
    }
}


class ToothpicksScripts : ObjectScripts {
    override var zIndex: Int32 { 21 }
    
    override var inventoryImage: String {
        if Toothpicks.areMatches { return "Matches" }
        if Toothpicks.hasFertilizer { return "ToothpicksWithFertilizer" }
        if Toothpicks.wet { return "ToothpicksWet" }
        return "Toothpicks"
    }
    
    override var name: String {
        if Toothpicks.areMatches { return "Working matches" }
        if Toothpicks.hasFertilizer { return "Almost working matches" }
        if Toothpicks.wet { return "Wet toothpicks" }
        return "Toothpicks"
    }
    
    override func combinesWith() -> [Object.Type] {
        [ArcadePlant.self, MainteinanceGirl.self, DragonTooth.self, Balloon.self, HiddenCoffeeCup.self]
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        !inventory.contains(self) && !MainteinanceGirl.hasMatches
    }
    
    override func onUse() {
        if inventory.contains(self) {
            return ScriptSay("I could hurt myself...")
        }
        let pirate = roomObject(Pirate.self)!
        Script {
            WalkToAndPickup(self, sound:"take_toothpicks")
            Say("May I?")
            Say(actor: pirate, "Arrh. I've no teeth left in me mouth, so... yes.")
        }
    }
    
    override func onMouthed() {
        if Toothpicks.hasFertilizer {
            return ScriptSay("You know fertilizer is usually made from animals excrements, right?")
        }
        Script {
            SetTrue(&Toothpicks.wet)
            Say("They taste sooo good!!", sound:"taste_toothpicks")
            ReloadInventory(self)
            Autosave()
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let dragonTooth = object.scripts as? DragonToothScripts {
            return dragonTooth.useWith(scriptedObject as! Toothpicks)
        }
        
        if let leia = object.scripts as? MainteinanceGirlScripts {
            return leia.give(toothpicks: scriptedObject as! Toothpicks)
        }
        
        if let plant = object as? ArcadePlant {
            return useWith(plant)
        }
        
        if let balloon = object as? Balloon {
            return useWith(balloon)
        }
        
        if let dark = object as? HiddenCoffeeCup {
            return useWith(dark, reversed:reversed)
        }
        
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ plant:ArcadePlant){
        if Toothpicks.wet {
            Script {
                Walk(to: plant)
                SetTrue(&Toothpicks.hasFertilizer)
                Animate("pickup", sound:"use_toothpicks_with_plant")
                Say("Yeah! Looks like I made some matches! Now I just need some kind of igniter...")
                ReloadInventory(self)
                Autosave()
            }
        } else {
            Script {
                Walk(to: plant)
                Say("The fertilizer doesn't stick to the toothpicks")
            }
        }
    }
    
    func useWith(_ balloon:Balloon){
        Script {
            Combine(self, losing: balloon.scripts, settingTrue: &Balloon.poped) {
                Say(actor:balloon, "* POP *")
                Say("Bye bye, balloon!")
            }
        }
    }
    
    private func useWith(_ dark:HiddenCoffeeCup, reversed:Bool){
        if Toothpicks.areMatches {
            return ScriptSay("The matches are no match for that darkness")
        }
        super.onUseWith(dark, reversed:reversed)
    }
    
    override func onLookedAt() {
        if Toothpicks.areMatches    { return ScriptSay("Perfectly working matches!") }
        if Toothpicks.hasFertilizer { return ScriptSay("Some matches, without an igniter") }
        if Toothpicks.wet           { return ScriptSay("Sticky wet toothpicks...") }
        ScriptSay("Toothpicks. To clean some teeth or looks stylish as heck with.")
    }
}

class ArcadeMachineButtonScripts : ObjectScripts {
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup")
            if ArcadeMachineButton.pushed {
                Say("Guess my luck's run out – no more coins...")
            } else {
                Say("I knew it was my lucky day! An arcade coin")
                Animate("pickup", sound:"take_coin")
                Pickup(Coin())
                SetTrue(&ArcadeMachineButton.pushed)
                Autosave()
            }
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Nothing out of the ordinary")
        }
    }
}

class CoinScripts : ObjectScripts {
    
    override func combinesWith() -> [Object.Type] {
        [TinyHeroArcade.self, BowlingScreen.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let bowling = object as? BowlingScreen {
            return useWith(bowling: bowling)
        }
        
        if let tinyShooter = object as? TinyHeroArcade {
            return useWith(tinyShooter: tinyShooter)
        }
        
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(bowling:BowlingScreen){
        let earnedTickets = EarnedTickets()
        let bowlingTickets = roomObject(BowlingTickets.self)!
        
        BowlingTicketsScripts.show = true
        Script ({
            Walk(to: bowling)
            Animate("pickup")
            Animate(actor:bowling.scripts, "play", ms:5600)
            Say("Yeaaaaah")
            AddToRoom(bowlingTickets)
            Walk(to: bowlingTickets)
            Animate("pickup", sound:"take_tickets")
            RemoveFromRoom(bowlingTickets)
            Lose(self, settingTrue:&Coin.used)
            SetTrue(&EarnedTickets.gotBowlingOnes)
            
            if !inventory.contains(earnedTickets) {
                Pickup(earnedTickets)
            }

            ReloadInventory(earnedTickets)
            
            Autosave()
        }){
            BowlingTicketsScripts.show = false
        }
    }
    
    func useWith(tinyShooter:TinyHeroArcade){
        Script {
            Walk(to: tinyShooter)
            Animate("pickup")
            Say("Oops, it fell down. Let's try again!")
            Animate("pickup")
            Say("...")
            Animate("pickup")
            Animate(nil)
            Animate("pickup")
            Animate(nil)
            Animate("pickup")
            Animate(nil)
            Wait(ms: 1500)
            Animate("pickup")
            Animate(nil)
            Animate("pickup")
            Animate(nil)
            Animate("pickup")
            Wait(ms: 1000)
            Face(.front)
            Say("Musk it! Looks like the machine's not accepting THIS coin...")
            Say("I need to find something else")
        }
    }
    
    override func onMouthed() {
        Game.shared.scene.inventoryUI.hide()
        Script {
            //Animate(Crypto.handToMouth)
            Say("Completely real")
        }
    }
    
    override func onLookedAt() {
        ScriptSay("As my grampa always said: 'Every fortune starts with just one coin'. Wonder how he knew - he died penniless!")
    }
}

class CoffeeCupScripts : ObjectScripts {
    
    override var inventoryImage: String {
        "CoffeeCup\(CoffeeCupScripts.howManyDoIHave())"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Barman.self, Pirate.self, MainteinanceGirl.self, Revisor.self, SupremeHacker.self]
    }
    
    static func howManyDoIHave() -> Int {
        var count = 0
        if CoffeeCup.gotHiddenOne     { count += 1 }
        if CoffeeCup.gotBarOne        { count += 1 }
        if CoffeeCup.gotEnentranceOne { count += 1 }
        if CoffeeCup.gotBasementOne   { count += 1 }
        return count
    }
    
    static func gotThemAll() -> Bool {
        CoffeeCup.gotHiddenOne &&
        CoffeeCup.gotBarOne &&
        CoffeeCup.gotEnentranceOne &&
        CoffeeCup.gotBasementOne
    }
    
    static func sayGotThemAll() -> Say {
        Say("I got enough cups to get the special deal!")
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if ReuseCoffeeCupsPromo.isRead, let barman = object as? Barman {
            return give(to: barman)
        }
        
        if let person = object as? Talks {
            return useWith(person)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ person:Talks){
        if Self.gotThemAll() {
            return ScriptSay("Yeah, I got them all! I should go and give them to the barman!")
        }
        Script {
            if let npc = person as? NonPlayableCharacter {
                Walk(to: npc)
            }
            Say("You don't happen to have a used coffee cup, do you?", expression: .small)
            Say(actor: person, random: [
                "Not anymore",
                "Nay, mate. I'm sorry.",
                "Why don't you buy one yourself?"
            ])
        }
    }
    
    
    override func onLookedAt(){
        Script {
            Say("I got...")
            Say("... \(Self.howManyDoIHave())")
        }
    }
    
    func give(to barman:Barman){
        Script {
            Walk(to: barman)
            Say("Hey! I got the used coffee cups...")
            Say("Can I have my free cocktail now?")
            Animate("pickup")
            
            if !Self.gotThemAll() {
                Say(actor:barman, "I'm afraid you need 4 to get the special offer.")
                if CoffeeCup.gotBarOne {
                    Say("I know... I'll keep looking")
                } else {
                    Say(actor:barman, "Since you are new here, I can make you one for free!")
                    Say("Sure, why not?", expression: .love)
                    Animate("pickup")
                    //Animate(Crypto.handToMouth)
                    Say("Ahhh! There's nothing like a freshly brewed coffee!", expression: .happy2)
                    CoffeeCupPicker(which: &CoffeeCup.gotBarOne)
                    Autosave()
                }
            } else {
                Say(actor:barman, "That's impressive! you are the first one to bring back the used coffee cups")
                Say(actor:barman, "A special occasion like this deserves a SPECIAL cocktail!")
                Animate(actor:barman, "make-cocktail", ms:1500)
                Animate("pickup", sound:"take_cocktail")
                Say("Neat")
                Lose(self, settingTrue: &Barman.madeTheCocktail)
                Pickup(Cocktail())
                Autosave()
            }
        }
    }
}

class CoffeeCupPicker : CompletableAction {
    
    init(which:inout Bool){
        which = true
    }
    
    func run(then: @escaping () -> Void) {
        let coffeeCup = CoffeeCup()
        Script({
            if !inventory.contains(coffeeCup){
                Pickup(coffeeCup)
            }
            ReloadInventory(coffeeCup)
            if CoffeeCupScripts.gotThemAll() {
                Face(.front)
                CoffeeCupScripts.sayGotThemAll()
            }
        }) {
            then()
        }
    }
}

class CocktailScripts : ObjectScripts {
    override var inventoryImage: String { Sand.isMud ? "CocktailEmpty" : "Cocktail" }
    
    override var name: String {
        Sand.isMud ? "Empty cocktail" : "Cocktail"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Sand.self, Pirate.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let sand = object.scripts as? SandScripts {
            return useWith(sand)
        }
        if let pirate = object as? Pirate{
            return useWith(pirate)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ sand:SandScripts){
        if Sand.isMud {
            return ScriptSay("There's no more liquid...")
        }
        Script {
            Combine(self, losing: nil, settingTrue: &Sand.isMud) {
                Say("Amazing! I have perfect modelling clay now!")
                Face(.front)
                Say("Did you know I can replicate almost anything I see with it? It's my special skill")
                Pickup(Ice())
                Say("I'll keep the ice apart")
                Autosave()
            }
        }
    }
    
    func useWith(_ pirate:Pirate){
        if Sand.isMud {
            return ScriptSay("I don't think he wants an empty cocktail")
        }
        Script {
            Walk(to: pirate)
            Say("Do you want a fresh cocktail?")
            Say(actor: pirate, "Arr, mate, I only drink grog", expression: .angry)
        }
    }
    
    override func onMouthed() {
        ScriptSay("I never drink when I'm on duty")
    }
    
    override func onLookedAt() {
        if Sand.isMud {
            return ScriptSay("I've used up all the liquid to make the clay.")
        }
        ScriptSay("Too bad I don't drink while on duty")
    }
}

class BarmanScripts : ObjectScripts {
    
    override func combinesWith() -> [Object.Type] {
        [CoffeeCup.self]
    }
    
    override func onMouthed() {
        Script {
            Walk(to: self)
            Talk(yack: BarmanYack(self.scriptedObject as! Barman))
        }
    }
    
    override func onLookedAt() {
        ScriptSay("Man, must be hard to smile all day long like a Cheshire cat!")
    }
}


class PirateScripts : ObjectScripts {
    
    override func onMouthed() {
        Script {
            Walk(to: self)
            Talk(yack: PirateYack(self.scriptedObject as! Pirate))
        }
    }
    
    override func onLookedAt() {
        ScriptSay("He's kinda scary...I better not stare at him for too long.")
    }
}

class ReuseCoffeeCupsPromoScripts : ObjectScripts {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("It says...")
            Say("Be ECO! be SMART! be HAPPY!")
            Say("Bring back 4 used coffee cups and get 1 free cocktail from our bar!")
            Say("Valid until midnight")
            SetTrue(&ReuseCoffeeCupsPromo.isRead)
            Autosave()
        }
    }
}

class IceScripts : ObjectScripts  {
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let pill = object.scripts as? PillBagScripts {
            return pill.useWith(self)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    override func onLookedAt() {
        ScriptSay("Ha. Weird it isn't melting... But hey - convenient, too!")
    }
}


class BowlingTicketsScripts : ObjectScripts  {
    static var show:Bool = false
    
    override func shouldBeAddedToRoom() -> Bool {
        Self.show
    }
}

class BowlingScreenScripts : ObjectScripts  {
    
    override func animate(_ animation: String?) {
        if animation == nil {
            scriptedObject.getNode()?.removeAllActions()
            (scriptedObject.getNode() as? Sprite2D)?.set(texture: "bowling-screen")
            return
        }
        
        (scriptedObject.getNode() as? Sprite2D)?.animate([
            texture("bowling-screen")!,
            texture("bowling-screen-01")!,
            texture("bowling-screen-02")!,
            texture("bowling-screen-03")!,
            texture("bowling-screen-empty")!,
            texture("bowling-screen-03")!,
            texture("bowling-screen-empty")!,
            texture("bowling-screen-04")!,
            texture("bowling-screen-empty")!,
            texture("bowling-screen-04")!,
            texture("bowling-screen-empty")!,
            texture("bowling-screen-04")!,
            texture("bowling-screen-empty")!,
            texture("bowling-screen-04")!,
        ], timePerFrame: 0.4)
    }
    
    override func onPhoned() {
        Script {
            WalkToAndSay(self, "Um, not a good idea, there's people looking!", expression: .sad)
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "I am the worst at this game", expression: .sad)
        }
    }
}

class OutOfOrderSignScripts : ObjectScripts  {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Looks like those arcade machines are out of order")
        }
    }
}

class RevoIpadScripts : ObjectScripts  {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("Wow, look at that magnificent POS system! Cloud based, instant configuration...")
            Say("... fully featured, it counts with any kind of integration you can think of")
            Say("a must-have if you own a restaurant or bar!")
            Say("Revo POS for restaurants")
            Say("Check it out at https://revo.works now!")
        }
    }
}

class PlayAloneSignScripts : ObjectScripts  {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("It says...")
            Say("... We recommend you don't play alone. The Management.")
        }
    }
}
