import Foundation
import SwiftGodot

//Music: https://www.storyblocks.com/audio/stock/story-time-forest-346759904.html
class ArcadeEntranceScripts : RoomScripts {
    
    override func onEnter() {
        if ArcadeEntrance.entered { return }
        
        inventory.pickup(ArcadeNote())
        //inventory.pickup(CheatSheet())
        let revisor = roomObject(Revisor.self)!
        let arcadeDoor = roomObject(EntranceToArcadeDoor.self)!
        Script ({
            BlackCutScene(fadingIn: false, texts: [
                "DISK 1",
                "The Arcade Palace"
            ])
            Face(.back)
            Say("Holy Turing, finally: the Arcade Palace!")
            Face(.left)
            Say("It took me six long months to find the place...", armsExpression:.shy)
            Say("... and with a bit of luck, he'll be here: the man I've been looking for for ages.")
            Say("The living legend, the god of cyberspace", armsExpression:.explain)
            Say("The supreme hacker!!!", armsExpression:.fist)
            Face(.front)
            Say("No code is safe from him, no government in the world can catch him. Nobody knows who he is, what he is, where he is.")
            Say("But I'll do the impossible. I will find him and get him to teach me everything he knows to help me become an elite hacker!", expression: .focus)
            Say("I remember it like it was yesterday. I was just doing my hacker stuff when, all of a sudden, I got a text message from an unknown number")
            //Tool used to encrypt https://www.devglan.com/online-tools/jasypt-online-encryption-decryption
            Say("All it said was...")
            Say("SuTaRGTncCj9fah...qUJqNIFjG+8GCLykHJ - SUPREME HACKER")
            Say("No matter what I tried, the sender couldn't be traced, the code couldn't be cracked", expression:.sad)
            Say("I was THAT close to giving up when it came to me: I used my own nickname to decrypt the message", expression:.surprise)
            Say("And lo and behold - all of a sudden, it was there in black and white:")
            Say(">> Come to the Arcade Palace to become an elite hacker. And remember: 'The strength is gold' – whatever that's supposed to mean.", expression:.suspicious)
            Say("...")
            Say("So here I am. Ready to become an elite hacker!", expression: .focus)
            Say("All I have to do is get into the joint and find my hero", expression: .focus)
            Say("Easy peasy, right?", expression: .happy1)
            Walk(to: arcadeDoor)
            Say(actor: revisor, "Hey! Stop it right there!", expression: .angry)
            Face(.left)
            Say("Um, are you talking to me?", expression: .surprise, armsExpression:.bored)
            Say(actor: revisor, "Who else?")
            Say(actor: revisor, "Where do you think you're going, pipsqueak? And where are your parents? You're too young to go in there!", expression: .angry)
            Walk(to: revisor)
            Talk(yack: RevisorYack(revisor))
            SetTrue(&ArcadeEntrance.entered)
        }) {
            //Game.shared.menu.showHowToPlay()
        }
    }
}

extension ArcadeNote {
    override func onLookedAt() {
        Script {
            Say("It says...")
            Say(">> Come to the palace to become an elite hacker, and remember that the strength is gold <<")
        }
    }
}

extension Balloon {
    
    var voiceType: VoiceType { .none }
    
    var inventoryImage: String { Self.painted ? "BalloonFace" : "Balloon" }
    
    override func combinesWith() -> [Object.Type] {
        [CarOil.self, Revisor.self, Barman.self]
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        !inventory.contains(self) && !Balloon.poped
    }
    
    override func onUse() {
        guard !inventory.contains(self) else {
            return ScriptSay("I should find the Supreme Hacker instead of playing with the balloon!")
        }
        
        Script {
            WalkToAndPickup(self, sound:"take_balloon")
            Say("Don't blow!")
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let oil = object as? CarOil {
            return oil.onUseWith(self, reversed:reversed)
        }
        if let revisor = object as? Revisor {
            return useWith(revisor)
        }
        if let barman = object as? Barman{
            return useWith(barman)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ revisor:Revisor){
        guard Balloon.painted else {
            return ScriptSay("I don't think he wants to play with it. Somehow, he doesn't strike me as the playful type.")
        }
        let door = roomObject(EntranceToArcadeDoor.self)!
        Script {
            Walk(to: revisor)
            Say("Hey, mister! Look, I just called my mum to take me to the arcade!")
            //Animate(Crypto.withBalloon)
            Say(actor: revisor, "Wasn't so hard now, was it, little one? Nice kid you got there, Ma'am!")
            Say("** Um, thank you! Isn't he a cutie? **")
            Say(actor: revisor, "Behave yourself in there, kid! No cheating or any other tomfoolery! I got eyes everywhere!")
            SetTrue(&RevisorYack.canGoIn)
            Autosave()
            GoThroughDoor(door)
        }
    }
        
    func useWith(_ barman:Barman){
        guard BarmanYack.knowsAboutCocktailGrownUp else {
            Script {
                Walk(to: barman)
                Say("Wanna play?")
                Say(actor:barman, "Yes! I'll finish my shift at 12 PM sharp.")
                Say("I hope I'm not here anymore by that time")
            }
            return
        }
        Script {
            Walk(to: barman)
            Say("Hey, look! I just called my mum so she can get the cocktail!", expression: .happy)
            Animate(Crypto.withBalloon)
            Say(actor:barman, "Um... Your mum's a BALLOON??", expression: .suspicious)
            Say("Well... yes..? It worked before...", expression: .sad)
            Say(actor:barman, "I see. I'm very sorry, but your only chance is to get the used cups.")
        }
    }
    
    override func onLookedAt() {
        if Self.painted {
            return ScriptSay("A happy balloon")
        }
        return ScriptSay("A lonely balloon")
    }
}

extension VanFront {
    override var zIndex: Int32 { 5 }
    //override func isTouched(point: Vector2) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
}

extension CarOil {
    override func combinesWith() -> [Object.Type] {
        [Balloon.self, PillBag.self]
    }
    
    override func onUse() {
        guard !inventory.contains(self) else {
            return ScriptSay("I'd rather not")
        }
        
        Script {
            WalkToAndPickup(self, sound:"take_oil")
            Say("I hope this'll come off again, eventually!")
        }
    }
    
    override func onMouthed() {
        ScriptSay("I'm not thirsty right now")
    }
    
    override func onLookedAt() {
        ScriptSay("A puddle of engine oil, all black and sticky. Yuck!", expression: .ouch)
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let pill = object as? PillBag {
            return pill.useWith(self)
        }
        
        guard let balloon = object as? Balloon else {
            return super.onUseWith(object, reversed:reversed)
        }
                
        if Balloon.painted {
            return ScriptSay("Man, take a look at this - ART!")
        }
        
        Script {
            if !inventory.contains(self) {
                WalkToAndPickup(self)
            }
            Combine(balloon, losing: self, settingTrue: &Balloon.painted){
                Autosave()
                Say("Man, hacker AND artist – I'm a whizz-kid!")
            }
        }
    }
}

extension MultiUseKnife {
    
    override func combinesWith() -> [Object.Type] {
        [PunchBag.self, ToyArrow.self, SmashHammer.self, TicketsBox.self, Balloon.self]
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        !inventory.contains(self) && !ToyArrow.isCutGlass
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let toy = object as? ToyArrow {
            return toy.useWith(knife: self)
        }
        if let punchBag = object as? PunchBag {
            return useWith(punchBag: punchBag)
        }
        if let hammer = object as? SmashHammer {
            return hammer.onUseWithKnife()
        }
        if let ticketBox = object as? TicketsBox{
            return useWith(ticketBoxs: ticketBox)
        }
        if let balloon = object as? Balloon {
            return useWith(balloon)
        }
        return super.onUseWith(self, reversed:reversed)
    }
    
    func useWith(punchBag:PunchBag){
        if PunchBag.isCut {
            return ScriptSay("Nah, I think I slashed that thing enough already.")
        }
        return PunchBagScripts(object: punchBag).useWith(knife: self)
    }
    
    func useWith(_ balloon:Balloon){
        Script {
            Combine(self, losing: balloon, settingTrue: &Balloon.poped) {
                Say(actor:balloon, "* POP *")
                Say("Bye bye, balloon!")
            }
        }
    }
    
    func useWith(ticketBoxs:TicketsBox){
        ScriptSay("I can't cut the glass with this alone")
    }
    
    override func onLookedAt() {
        ScriptSay(random:[
            "Man, I can imagine at least a THOUSAND things I could do with that thing!",
            "The multi-purpose knife every kid dreams of!"
        ])
    }
}

extension BowlingBall {
    
    override func combinesWith() -> [Object.Type] {
        [PunchBag.self, BowlingScreen.self]
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        !RevisorYack.gotGoldenBall
    }
    
    override func onLookedAt() {
        ScriptSay("It's a golden bowling ball, glistening like a tiny sun!", expression: .love)
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let punchBag = object as? PunchBag {
            return useWith(punchBag: punchBag)
        }
        if let bowling = object as? BowlingScreen{
            return useWith(bowling: bowling)
        }
        super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(punchBag:PunchBag){
        if !inInventory{
            return ScriptSay("I should get the bowling ball first...")
        }
        if !PunchBag.isCut {
            return ScriptSay("How exactly would I mix those?")
        }
        Script {
            Combine(punchBag, losing: self, settingTrue: &PunchBag.hasGoldenBall){
                Say("The strength is gold!")
                Autosave()
            }
        }
    }
    
    func useWith(bowling:BowlingScreen){
        ScriptSay("I'm afraid the machine will keep the ball")
    }
}

extension Revisor {
    override func combinesWith() -> [Object.Type] {
        [EarnedTickets.self, Balloon.self]
    }
    
    
    override func onLookedAt() {
        Script {
            Say("The vendor's wearing coke-bottle glasses.")
            Say("Obviously, the old man can no longer see so well.")
        }
    }
    
    override func onMouthed() {
        if RevisorYack.isNotLooking {
            return ScriptSay("Not now")
        }
        
        Script([
            Walk(to: self),
            Talk(yack: RevisorYack(self))
        ])
    }
}

extension MainteinanceGirl {
    override func combinesWith() -> [Object.Type] {
        [Toothpicks.self]
    }
    
    override func onLookedAt() {
        Script {
            Say("She is trying to fix a ... whatever that gizmo is. My guess is, she works at the Arcade Palace.")
        }
    }
    
    override func onMouthed() {
        if RevisorYack.isNotLooking {
            return ScriptSay("Not now")
        }
        
        Script {
            Walk(to: self)
            Talk(yack: MainteinanceGirlYack(leia: self))
        }
    }
    
    func give(toothpicks:Toothpicks){
        if !MainteinanceGirlYack.knowsWhatSheIsDoing{
            return ScriptSay("Why would she want it?")
        }
        Script {
            Walk(to: self)
            Animate("pickup")
            if !Toothpicks.areMatches {
                Say(actor:self, "Why would I want it?")
            } else {
                Say("I think this can help you")
                Animate("pickup")
                Say(actor:self, "Thank you, you saved my day!")
                Say("Would you lend me your lighter now?")
                Say(actor:self, "Sure, here you go. But unfortunately, it doesn't work, so.. what's the use?")
                Animate("pickup")
                Pickup(Lighter())
                Lose(toothpicks, settingTrue: &Self.hasMatches)
                Animate(actor: self, "matches", sound:"maintenance_matches_start")
                Autosave()
            }
        }
    }
}

extension TicketsBox {
    override func combinesWith() -> [Object.Type] {
        [ToyArrow.self, MultiUseKnife.self]
    }
    
    override var image: String {
        EarnedTickets.gotTicketBoxOnes ? "TicketBoxStolen.png" : "TicketBox.png"
    }
    
    override var name: String {
        EarnedTickets.gotTicketBoxOnes ? "Empty tickets box" : "Tickets box"
    }
    
    override func onLookedAt() {
        if EarnedTickets.gotTicketBoxOnes {
            return ScriptSay("Empty")
        }
        ScriptSay("The ticket booth contains all the redeemed tickets. Must be hundreds. Or thousands.", expression: .focus)
    }
    
    override func onUse() {
        ScriptSay("They are safely locked in that glass box...")
    }
}

extension EntranceToArcadeDoor {
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        
        if RevisorYack.isNotLooking {
            Script({
                Say("Not now")
            }){
                then(false)
            }
            return
        }
        
        if RevisorYack.canGoIn {
            return then(true)
        }
        let revisor = roomObject(Revisor.self)!
                
        Script ({
            Walk(to: self)
            Say(actor: revisor, "Hey! Stop it right there!", expression: .angry)
            Say(actor: revisor, "You deaf, kid? You need a grown-up to go in!", expression: .angry)
        }){
            then(false)
        }
    }
}

extension Lighter {
    
    override func combinesWith() -> [Object.Type] {
        [ArcadeMachineButton.self, BowlingScreen.self, TinyHeroArcade.self, ArcadePlant.self, ArcadeMachineButton.self, HiddenCoffeeCup.self]
    }
        
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let bowling = object as? BowlingScreen {
            return onUseWith(bowling: bowling)
        }

        if let tinyShooterMachine = object as? TinyHeroArcade {
            return onUseWith(tinyHero: tinyShooterMachine)
        }
        
        if let plant = object as? ArcadePlant {
            return onUseWith(plant: plant)
        }
        
        if object is HiddenCoffeeCup {
            return ScriptSay("The lighter is not working...")
        }
        
        super.onUseWith(object, reversed:reversed)
    }
    
    func onUseWith(bowling:BowlingScreen) {
        Script {
            Walk(to: bowling)
            Say("Um, not a good idea, there's people looking!", expression: .sad)
        }
    }
    
    func onUseWith(plant:ArcadePlant) {
        Script {
            Say("Careful. Don't wanna start a fire!")
        }
    }
    
    func onUseWith(tinyHero:TinyHeroArcade){
        if TinyHeroArcade.played {
            return ScriptSay("Unfortunately, I've got no more time for playing, I got things to do!")
        }
        let earnedTickets = EarnedTickets()
        let arcadeTickets = roomObject(ArcadeTickets.self)!
        
        ArcadeTickets.show = true
        Script ({
            Walk(to: tinyHero)
            if !PirateYack.toldAboutLighterTrick {
                Say("Don't really know what could I do with it...")
            } else {
                Say("Let's see if that lighter trick works here...")
                Animate("pickup")
                SetTrue(&TinyHeroArcade.played)
                BlackCutScene(texts: [
                    "4 Hours later"
                ], sound: "title_time")
                Say("This game is so addictive!")
                AddToRoom(arcadeTickets)
                Walk(to: arcadeTickets)
                Animate("pickup", sound:"take_tickets")
                RemoveFromRoom(arcadeTickets)
                SetTrue(&EarnedTickets.gotTinyShooterOnes)
                
                if !inventory.contains(earnedTickets) {
                    Pickup(earnedTickets)
                }
                
                ReloadInventory(earnedTickets)
                Autosave()
            }
        }){
            ArcadeTickets.show = false
        }
    }
    
    override func onLookedAt() {
        ScriptSay("It's out of gas")
    }
}

extension ArcadeEntranceCoffeeCup {
    
    override func shouldBeAddedToRoom() -> Bool {
        !CoffeeCup.gotEnentranceOne
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup-low", sound:"take_coffee_cup")
            RemoveFromRoom(self)
            CoffeeCupPicker(which: &CoffeeCup.gotEnentranceOne)
            Autosave()
        }
    }
}

extension Rabbit {
    override var image: String {
        if Self.hasBeenSwapped { return "EntranceRabbitSwapped.png" }
        return "EntranceRabbit.png"
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        true
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let pill = object as? PillBag {
            return pill.useWith(self)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    override func onLookedAt() {
        if inventory.contains(self) {
            return ScriptSay("I've managed to swap it and get the official arcade palace white rabbit")
        }
        if SupremeHackerBasement.entered {
            return ScriptSay("I need to find a way to get it!")
        }
        ScriptSay("A cute rabbit", expression: .love)
    }
}

extension TicketsCounterDisplay : Animable {
    
    override var image: String {
        "tickets-counter-plain.png"
    }
    
    func animate(_ animation: String?) {
        /*node?.removeAllActions()
        if animation == nil {
            node?.run(.setTexture(texture("tickets-counter-plain")))
        }
        else if animation == "count" {
            node?.run(.repeatForever(.animate(with: [
                texture("tickets-counter-counting-00"),
                texture("tickets-counter-counting-01")
            ], timePerFrame: 0.2)))
        }
        else {
            node?.run(.setTexture(texture("tickets-counter-\(animation!)")))
        }*/
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "It's a ticket counting machine. You put the tickets in there, and it tells you how many you got.")
        }
    }
    
    override func onPhoned() {
        ScriptSay("I don't think it can be hacked at all")
    }
    
}


extension MoreThan18YearsSign {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("It says...")
            Say("All children under the age of 18 must be accompanied by an adult")
        }
    }
}

extension WinTickets {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Earn tickets at our machines and win spectacular prizes")
        }
    }
}

extension Minions {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "I hope they don't make more movies, I can't stand that voice anymore")
        }
    }
}
