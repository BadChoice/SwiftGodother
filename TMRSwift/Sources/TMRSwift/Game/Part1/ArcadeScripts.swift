import Foundation
import SwiftGodot

class ArcadeScripts : RoomScripts {
    override func onEnter(){
        if Arcade.entered { return }
        Script {
            SetTrue(&Arcade.entered)
            Autosave()
        }
    }
}

class PunchBagScripts : ObjectScripts {
    
    override func combinesWith() -> [Object.Type] {
        [MultiUseKnife.self, PunchMachine.self, BowlingBall.self]
    }
    
    override var inventoryImage: String {
        if PunchBag.hasGoldenBall { return "PunchBagGoldenBall" }
        if PunchBag.isCut { return "PunchBagOpen" }
        return "PunchBag"
    }
    
    override var image: String {
        if PunchBag.hasGoldenBall { return "punch-bag-gold.png" }
        return "punch-bag.png"
    }
    
    override var name: String {
        if PunchBag.hasGoldenBall { return "Golden punch bag" }
        if PunchBag.isCut { return "Empty punch bag" }
        return "Punch bag"
    }
    
    override func onUse() {
        if inventory.contains(scriptedObject as! PunchBag) {
            return super.onUse()
        }
        if PunchMachine.hasGoldenPunchBag {
            return ScriptSay("Nah, I don't want the trap door to be closed again!")
        }
        Script {
            WalkToAndPickup(scriptedObject as! PunchBag, sound:"take_punch_bag")
            Say("Nobody will miss it")
            Autosave()
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let knife = object.scripts as? MultiUseKnifeScripts {
            return useWith(knife: knife)
        }
        if object is ToyArrow && ToyArrow.isCutGlass {
            return useWith(knife: MultiUseKnifeScripts(object: MultiUseKnife()))
        }
        if let bowlingBall = object.scripts as? BowlingBallScripts {
            return bowlingBall.useWith(punchBag: self)
        }
        if let punchMachine = object as? PunchMachine {
            return useWith(punchMachine: punchMachine)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(knife: MultiUseKnifeScripts) {
        if !inventory.contains(knife) && !ToyArrow.isCutGlass {
            return ScriptSay("That would be a good idea... if I had the knife!")
        }
        guard !PunchBag.isCut else {
            return ScriptSay("I've got everything I could from it.")
        }
        if !(scriptedObject as! PunchBag).inInventory {
            Script {
                Say("It would be nice if I had BOTH of them in my inventory")
                WalkToAndPickup(scriptedObject as! PunchBag)
            }
            return
        }
        Script {

            Combine(scriptedObject as! PunchBag, losing: nil, settingTrue: &PunchBag.isCut) {
                Pickup(Sand())
                Say("Yeah, as I thought - it's a punching bag filled with sand.")
                Autosave()
            }
        }
    }
    
    func useWith(punchMachine: PunchMachine){
        if !PunchBag.hasGoldenBall {
            return ScriptSay("Hmm, I think something's still missing...")
        }
        Script {
            Walk(to: punchMachine)
            Lose(scriptedObject as! PunchBag, settingTrue: &PunchMachine.hasGoldenPunchBag)
            Animate("pickup-up", sound:"hang_golden_ball")
            AddToRoom(scriptedObject)
            Walk(to: scriptedObject)
            Animate(actor: TrapDoor.findAtRoom().scripts, "open")
            Say("It worked!", expression: .happy2)
            Say("Supreme Hacker, here I come!", expression: .focus)
            Autosave()
        }
    }
    
    override func onLookedAt() {
        if PunchBag.hasGoldenBall {
            return ScriptSay("The STRENGTH is GOLD!")
        }
        Script {
            WalkToAndSay(scriptedObject, "Everybody wants one of those at home", expression: .star, armsExpression: .explain)
        }
    }
}

class DragonToothScripts : ObjectScripts {
    
    override func combinesWith() -> [Object.Type] {
        [Toothpicks.self, SmashHammer.self]
    }
    
    override func shouldBeAddedToRoom() -> Bool {
        !inventory.contains(self) && !Toothpicks.areMatches
    }
    
    override func onUse() {
        if inventory.contains(self) {
            return super.onUse()
        }
        Script {
            WalkToAndPickup(self, sound:"take_tooth")
            Say("Oops, It was already falling")
            Autosave()
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let toothpicks = object as? Toothpicks {
            return useWith(toothpicks)
        }
        if let hammer = object.scripts as? SmashHammerScripts {
            return hammer.onUseWithDragonTooth()
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ toothPicks:Toothpicks){
        if !Toothpicks.hasFertilizer{
            return ScriptSay("Ummm.... no.")
        }
        Script {
            Combine(toothPicks.scripts, losing: self, settingTrue: &Toothpicks.areMatches) {
                Say("Hey! I have some working matches now")
                Autosave()
            }
        }
    }
    
    override func onLookedAt() {
        ScriptSay("Sparky")
    }
}

class SmashHammerScripts : ObjectScripts {
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("It's firmly attached to the machine")
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let pill = object.scripts as? PillBagScripts {
            return pill.useWith(self)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func onUseWithKnife(){
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("This knife's not strong enough to cut the chain")
        }
    }
    
    func onUseWithDragonTooth(){
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("This tooth's not strong enough to cut the chain")
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Best stress relieving machine EVER.")
        }
    }
}

class ToyArrowScripts : ObjectScripts {
    
    override var inventoryImage: String {
        if ToyArrow.isCutGlass { return "ToyArrowWithMultiuseKnife"}
        return "ToyArrow"
    }
    
    override var name: String {
        ToyArrow.isCutGlass ? "Cutglass" : "Toy arrow"
    }
    
    override func combinesWith() -> [Object.Type] {
        [MultiUseKnife.self, TicketsBox.self, PunchBag.self, SmashHammer.self, Balloon.self]
    }
    
    override func onUse() {
        if inventory.contains(self) {
            return super.onUse()
        }
        Script {
            WalkToAndPickup(self, sound:"take_arrow")
            Autosave()
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let knife = object.scripts as? MultiUseKnifeScripts {
            return useWith(knife: knife)
        }
        
        if let ticketsBox = object as? TicketsBox {
            return useWith(ticketsBox: ticketsBox)
        }
        
        if let hammer = object.scripts as? SmashHammerScripts {
            if ToyArrow.isCutGlass {
                return hammer.onUseWithKnife()
            }
            return ScriptSay("Ummmm...no.")
        }
        if let balloon = object.scripts as? BalloonScripts, ToyArrow.isCutGlass {
            return useWith(balloon)
        }
        if ToyArrow.isCutGlass, let punchBag = object.scripts as? PunchBagScripts {
            return useWith(punchBag: punchBag, reversed:reversed)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(knife:MultiUseKnifeScripts){
        if !knife.inInventory {
            return ScriptSay("That would be a good idea... if I had the knife!")
        }
        Script {
            Combine(self, losing: knife, settingTrue: &ToyArrow.isCutGlass) {
                Say("I've built an amazing glass cutter!")
                Autosave()
            }
        }
    }
    
    func useWith(_ balloon:BalloonScripts){
        Script {
            Combine(self, losing: balloon, settingTrue: &Balloon.poped) {
                Say(actor: balloon.scriptedObject as! Balloon, "* POP *")
                Say("Bye bye, balloon!")
            }
        }
    }
    
    func useWith(ticketsBox:TicketsBox){
        if EarnedTickets.gotTicketBoxOnes {
            return ScriptSay("There are no more tickets in there")
        }
        RevisorYack.isStealingTickets = true
        Script ({
            if !ToyArrow.isCutGlass {
                Say("I think I need something else")
            } else if !RevisorYack.isNotLooking {
                Say("I can't do anything while he's looking!", expression: .sad)
            } else {
                Walk(to: ticketsBox)
                Animate("pickup", sound:"glass_cutter_put_on")
                ChangeSprite(object: ticketsBox, imageName: "TicketBoxWithCutGlass")
                Wait(ms: 1000)
                Animate("pickup", sound:"glass_cutter_cut")
                ChangeSprite(object: ticketsBox, imageName: "TicketBoxWithCutGlassCut")
                Wait(ms: 1000)
                Animate("pickup", sound:"glass_cutter_take_off")
                ChangeSprite(object: ticketsBox, imageName: "TicketsBoxWithCutGlassCutAndRemoved")
                Wait(ms: 1000)
                Animate("pickup")
                ChangeSprite(object: ticketsBox, imageName: "TicketBoxStolen")
                Say("Nothing happened", expression: .happy2)
                SetTrue(&EarnedTickets.gotTicketBoxOnes)
                ReloadInventory(EarnedTickets())
                Autosave()
            }
        }) {
            RevisorYack.isStealingTickets = false
        }
    }
    
    func useWith(punchBag:PunchBagScripts, reversed:Bool){
        if ToyArrow.isCutGlass {
            return MultiUseKnifeScripts(object: MultiUseKnife()).useWith(punchBag: punchBag)
        }
        super.onUseWith(punchBag.scriptedObject, reversed:reversed)
    }
    
    override func onLookedAt() {
        if ToyArrow.isCutGlass {
            return ScriptSay("A curved toy arrow with a knife attached to it. Brillant!")
        }
        ScriptSay("It has a peculiar curved shape")
    }
}

class ArcadePlantScripts : ObjectScripts {
    override func combinesWith() -> [Object.Type] {
        [Toothpicks.self, Lighter.self]
    }
    
    override func onLookedAt() {
        Script{
            WalkToAndSay(self, "This plant look amazing! Either it's getting some real good fertilizer - or a whole lot of love.")
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if object is Lighter {
            return ScriptSay("I don't want to alarm the fire department...")
        }
        return super.onUseWith(object, reversed:reversed)
    }
}

class EarnedTicketsScripts : ObjectScripts {
    
    override var inventoryImage: String {
        if RevisorYack.gotGoldenBall { return "EarnedTickets" }
        if EarnedTickets.gotTicketBoxOnes { return "EarnedTickets4" }
        if RevisorYack.gotMultiuseKnife { return "EarnedTickets" }
        if EarnedTickets.gotBowlingOnes && EarnedTickets.gotTinyShooterOnes { return "EarnedTickets3" }
        if EarnedTickets.gotBowlingOnes || EarnedTickets.gotTinyShooterOnes { return "EarnedTickets2" }
        return "EarnedTickets"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Revisor.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        guard let revisor = object as? Revisor else{
            return super.onUseWith(object, reversed:reversed)
        }
        
        let display = roomObject(TicketsCounterDisplay.self)!
        RevisorYack.isNotLooking = true
        Script ({
            Walk(to: revisor)
            Say("Could you count my tickets?")
            Say(actor: revisor, "Sure, let's see...")
            Animate("pickup")
            Animate(actor:revisor, "count-tickets", ms:0)
            Delay(ms: 1000)
            Animate(actor: display.scripts, "count", ms:0, sound:"count_tickets_start")
            if !RevisorYack.hasBeenDistracted {
                Face(.front)
                Say("Greeat, he's distracted! Now'd be the time to do something really clever!")
                SetTrue(&RevisorYack.hasBeenDistracted)
                Face(.left)
            }
            PlaySound("count_tickets_loop")
            PauseScriptWhilePlayerCanDoThings(ms: 10000)
            Walk(to: revisor)
            Animate(actor:display.scripts, EarnedTicketsScripts.howManyDoesCryptoHave(), ms:0)
            Animate(actor:revisor, "stop-count-tickets", ms:1200, sound:"count_tickets_end")
            Say(actor: revisor, "Got it")
            Animate("pickup")
            Say(actor:revisor, "There are...")
            Say(actor:revisor, EarnedTicketsScripts.howManyDoesCryptoHave() + " tickets")
            Animate(actor:display.scripts, nil)
        }) {
            RevisorYack.isNotLooking = false
        }
    }
    
    override func onLookedAt() {
        ScriptSay("Maybe I can give them to the vendor, so he can count how many I have?")
    }
    
    static func howManyDoesCryptoHave() -> String {
        if RevisorYack.gotGoldenBall { return "05" }
        if EarnedTickets.gotTicketBoxOnes { return "plain" }
        if RevisorYack.gotMultiuseKnife { return "05" }
        if EarnedTickets.gotBowlingOnes && EarnedTickets.gotTinyShooterOnes { return "50" }
        if EarnedTickets.gotBowlingOnes || EarnedTickets.gotTinyShooterOnes { return "25" }
        return "0"
    }
}

extension TinyHeroArcade {
    var voiceType: VoiceType { .machine }
    var talkPosition: Vector2 { Vector2(x:self.position.x, y: self.position.y + 100 * Float(Game.shared.scale)) }
}

class TinyHeroArcadeScripts : ObjectScripts {

    override var voiceType: VoiceType { .machine }
    
    override func combinesWith() -> [Object.Type] {
        [Lighter.self, Coin.self]
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("I think I need a coin or something to play it...")
        }
    }
    
    override func onPhoned() {
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("I can't hack it, it doesn't have any wireless signal")
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Pure nostalgia")
        }
    }
}

class NoLightersSignScripts : ObjectScripts {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("It says...")
            Say("... The use of lighters inside the Arcade Palace is strictly forbidden.")
            SetTrue(&NoLightersSign.read)
            Autosave()
        }
    }
}


class HiddenCoffeeCupScripts : ObjectScripts {
    override func shouldBeAddedToRoom() -> Bool {
        !CoffeeCup.gotHiddenOne
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Say("Come on, I won't put my hand down there! There might be bugs...or rats...or both!")
            SetTrue(&HiddenCoffeeCup.triedSomething)
            Autosave()
        }
    }
    
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("Looks like there's something interesting down there, but it's too dark...")
            SetTrue(&HiddenCoffeeCup.triedSomething)
            Autosave()
        }
    }
    
    override func onPhoned() {
        Script {
            Walk(to: self)
            Say("Ha-haa! I'll use my powerful phone flashlight!")
            Animate("pickup-low")
            Say("Cool, there's a used coffee cup down here!")
            Animate("pickup-low", sound:"take_coffee_cup")
            CoffeeCupPicker(which: &CoffeeCup.gotHiddenOne)
            RemoveFromRoom(self)
            Autosave()
        }
    }
}

class SandScripts : ObjectScripts {
    override var inventoryImage: String {
        if Sand.isWhiteRabbit { return "SandRabbitWhite" }
        if Sand.isRabbit { return "SandRabbit" }
        if Sand.isMud { return "PotteryClay "}
        return "Sand"
    }
    
    override var name: String {
        if Sand.isWhiteRabbit { return "White mud rabbit" }
        if Sand.isRabbit { return "Mud rabbit" }
        if Sand.isMud { return "Art mud" }
        return "Sand"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Cocktail.self, Rabbit.self, WhiteBallsBox.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let cocktail = object.scripts as? CocktailScripts {
            return cocktail.useWith(self)
        }
        if let whiteBallsBox = object as? WhiteBallsBox {
            return useWith(box: whiteBallsBox)
        }
        if let rabbit = object as? Rabbit {
            return useWith(rabbit: rabbit)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(rabbit:Rabbit){
        if !Sand.isMud{
            return ScriptSay("Nah...")
        }
        if !Sand.isRabbit {
            Script {
                Walk(to:rabbit)
                Say("I can replicate it!")
                Combine(self, losing: nil, settingTrue: &Sand.isRabbit) {}
            }
            return
        }
        if !Sand.isWhiteRabbit {
            Script {
                Face(.front)
                Say("I think even old Eagle Ears here will notice that this is not a WHITE rabbit.")
            }
            return
        }
        
        if !RevisorYack.isNotLooking {
            return ScriptSay("I can't do anything while he's looking!", expression: .sad)
        }

        RevisorYack.isStealingTickets = true
        Script ({
            Walk(to: rabbit)
            Animate("pickup-really-up")
            Pickup(rabbit, removeFromScene: false)
            Lose(self, settingTrue: &Rabbit.hasBeenSwapped)
            ReloadSprite(rabbit)
            Say("This will do it!", expression: .happy1)
            Autosave()
        }){
            RevisorYack.isStealingTickets = false
        }
    }
    
    func useWith(box:WhiteBallsBox){
        if Sand.isWhiteRabbit {
            return ScriptSay("I think it's white enough")
        }
        if Sand.isRabbit {
            Script {
                Walk(to: box)
                Animate("pickup-low", sound:"use_rabbit_with_balls")
                SetTrue(&Sand.isWhiteRabbit)
                ReloadInventory(self)
                Say("A white rabbit!")
            }
            return
        }
        ScriptSay("Why would I put it here?")
    }
    
    override func onLookedAt() {
        if Sand.isWhiteRabbit {
            return ScriptSay("A white rabbit made of clay.")
        }
        if Sand.isRabbit {
            return ScriptSay("A clay rabbit")
        }
        if Sand.isMud {
            return ScriptSay("It's clay! I can replicate anything I see with it!")
        }
        ScriptSay("Plain sand from the punching bag")
    }
}


class TrapDoorScripts : ObjectScripts {
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        let node = (scriptedObject as? TrapDoor)?.node
        if PunchMachine.hasGoldenPunchBag {
            node?.position = node!.position + Vector2(x: 50, y:80) * Game.shared.scale
            node?.scale = Vector2(value: 0.6)
        }
    }
    
    override func animate(_ animation: String?) {
        if animation == "open" {
            animateOpen()
        }
    }
    
    func animateOpen() {
        Game.shared.room.node.shake(intensity:8, duration:1)
        /*node?.run(.group([
            .moveBy(x: 50, y: 80, duration: 1),
            .scale(to: 0.6, duration: 1)
        ]))*/
    }
    
    override func onUse() {
        ScriptWalkToAndSay(self, "It's locked")
    }
    
    override func onLookedAt() {
        if PunchBag.hasGoldenBall {
            return ScriptSay("I finally solved the strength is gold riddle")
        }
        ScriptSay("I'm pretty sure this has something to do with the strength is gold riddle")
    }
}

class ArcadeToBasementDoorScripts : ObjectScripts {
    
    override func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        then(PunchMachine.hasGoldenPunchBag)
    }
}

/*class Smash00Scripts : ObjectScripts  {
    override func isTouched(point: Point) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        scriptedObject.getNode()?.run(.repeatForever(.animate(with: [
            texture("smash00"), texture("smash01"),
        ], timePerFrame: 0.3)))
    }
}

class Tinyshooter00Scripts : ObjectScripts  {
    //override func isTouched(point: CGPoint) -> Bool { false }
        
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        scriptedObject.getNode()?.run(.repeatForever(.animate(with: [
            texture("tinyshooter00"), texture("tinyshooter01"),
        ], timePerFrame: 0.25)))
    }
}

class Figther00Scripts : ObjectScripts  {
    override func isTouched(point: Point) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        scriptedObject.getNode()?.run(.repeatForever(.animate(with: [
            texture("figther00"), texture("fighter01"),
        ], timePerFrame: 0.35)))
    }
}*/

class ArcadeTicketsScripts : ObjectScripts {
    
    static var show:Bool = false
    
    override func shouldBeAddedToRoom() -> Bool {
        Self.show
    }
}

class ChangeMachineScripts : ObjectScripts {
    
    override func combinesWith() -> [Object.Type] {
        [Coin.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if object is Coin{
            return useWithCoin()
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("Nothing...")
        }
    }
    
    func useWithCoin(){
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("It doesn't give change for a simple coin.")
        }
    }
    
    override func onPhoned() {
        Script {
            Walk(to: self)
            //Animate(Crypto.usePhone)
            Say("It's so ANCIENT that it can't even be hacked!")
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "There are no coins left...")
        }
    }
}

class MaxKidScript : ObjectScripts {
    override func onMouthed() {
        Script {
            Walk(to: self)
            //Talk(yack: MaxYack(max: self))
        }
    }
    
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "She's incredibily focused on the game")
        }
    }
}

