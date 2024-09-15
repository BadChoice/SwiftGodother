import Foundation
import SwiftGodot

extension Arcade {
    override func onEnter(){
        if Arcade.entered { return }
        Script {
            SetTrue(&Arcade.entered)
            Autosave()
        }
    }
}

extension PunchBag {
    var inventoryImage: String {
        if Self.hasGoldenBall { return "PunchBagGoldenBall" }
        if Self.isCut { return "PunchBagOpen" }
        return "PunchBag"
    }
    
    override var image: String {
        if Self.hasGoldenBall { return "punch-bag-gold.png" }
        return "punch-bag.png"
    }
    
    override var name: String {
        if Self.hasGoldenBall { return "Golden punch bag" }
        if Self.isCut { return "Empty punch bag" }
        return "Punch bag"
    }
}

class PunchBagHandler : VerbsHandler {
    
   /* override func combinesWith() -> [Object.Type] {
        [MultiUseKnife.self, PunchMachine.self, BowlingBall.self]
    }
    
    var inventoryImage: String {
        if Self.hasGoldenBall { return "PunchBagGoldenBall" }
        if Self.isCut { return "PunchBagOpen" }
        return "PunchBag"
    }
    
    override var image: String {
        if Self.hasGoldenBall { return "punch-bag-gold.png" }
        return "punch-bag.png"
    }
    
    override var name: String {
        if Self.hasGoldenBall { return "Golden punch bag" }
        if Self.isCut { return "Empty punch bag" }
        return "Punch bag"
    }*/
    
    override func onUse() {
        if inventory.contains(handledObject as! PunchBag) {
            return super.onUse()
        }
        if PunchMachine.hasGoldenPunchBag {
            return ScriptSay("Nah, I don't want the trap door to be closed again!")
        }
        Script {
            WalkToAndPickup(handledObject as! PunchBag, sound:"take_punch_bag")
            Say("Nobody will miss it")
            Autosave()
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let knife = object as? MultiUseKnife {
            return useWith(knife: knife)
        }
        if object is ToyArrow && ToyArrow.isCutGlass {
            return useWith(knife: MultiUseKnife())
        }
        if let bowlingBall = object as? BowlingBall {
            return bowlingBall.useWith(punchBag: object as! PunchBag)
        }
        if let punchMachine = object as? PunchMachine {
            return useWith(punchMachine: punchMachine)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(knife: MultiUseKnife) {
        if !inventory.contains(knife) && !ToyArrow.isCutGlass {
            return ScriptSay("That would be a good idea... if I had the knife!")
        }
        guard !PunchBag.isCut else {
            return ScriptSay("I've got everything I could from it.")
        }
        if !(handledObject as! PunchBag).inInventory {
            Script {
                Say("It would be nice if I had BOTH of them in my inventory")
                WalkToAndPickup(handledObject as! PunchBag)
            }
            return
        }
        Script {

            Combine(handledObject as! PunchBag, losing: nil, settingTrue: &PunchBag.isCut) {
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
            Lose(handledObject as! PunchBag, settingTrue: &PunchMachine.hasGoldenPunchBag)
            Animate("pickup-up", sound:"hang_golden_ball")
            AddToRoom(handledObject)
            Walk(to: handledObject)
            Animate(actor: roomObject(TrapDoor.self)!, "open")
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
            WalkToAndSay(handledObject, "Everybody wants one of those at home", expression: .star, armsExpression: .explain)
        }
    }
}

extension DragonTooth {
    
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
        if let hammer = object as? SmashHammer {
            return hammer.onUseWithDragonTooth()
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(_ toothPicks:Toothpicks){
        if !Toothpicks.hasFertilizer{
            return ScriptSay("Ummm.... no.")
        }
        Script {
            Combine(toothPicks, losing: self, settingTrue: &Toothpicks.areMatches) {
                Say("Hey! I have some working matches now")
                Autosave()
            }
        }
    }
    
    override func onLookedAt() {
        ScriptSay("Sparky")
    }
}

extension SmashHammer {
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup")
            Say("It's firmly attached to the machine")
        }
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let pill = object as? PillBag {
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

extension ToyArrow {
    
    var inventoryImage: String {
        if Self.isCutGlass { return "ToyArrowWithMultiuseKnife"}
        return "ToyArrow"
    }
    
    override var name: String {
        Self.isCutGlass ? "Cutglass" : "Toy arrow"
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
        if let knife = object as? MultiUseKnife {
            return useWith(knife: knife)
        }
        
        if let ticketsBox = object as? TicketsBox {
            return useWith(ticketsBox: ticketsBox)
        }
        
        if let hammer = object as? SmashHammer {
            if Self.isCutGlass {
                return hammer.onUseWithKnife()
            }
            return ScriptSay("Ummmm...no.")
        }
        if let balloon = object as? Balloon, Self.isCutGlass {
            return useWith(balloon)
        }
        if Self.isCutGlass, let punchBag = object as? PunchBag {
            return useWith(punchBag: punchBag, reversed:reversed)
        }
        return super.onUseWith(object, reversed:reversed)
    }
    
    func useWith(knife:MultiUseKnife){
        if !knife.inInventory {
            return ScriptSay("That would be a good idea... if I had the knife!")
        }
        Script {
            Combine(self, losing: knife, settingTrue: &Self.isCutGlass) {
                Say("I've built an amazing glass cutter!")
                Autosave()
            }
        }
    }
    
    func useWith(_ balloon:Balloon){
        Script {
            Combine(self, losing: balloon, settingTrue: &Balloon.poped) {
                Say(actor:balloon, "* POP *")
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
            if !Self.isCutGlass {
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
    
    func useWith(punchBag:PunchBag, reversed:Bool){
        if Self.isCutGlass {
            return MultiUseKnife().useWith(punchBag: punchBag)
        }
        super.onUseWith(punchBag, reversed:reversed)
    }
    
    override func onLookedAt() {
        if Self.isCutGlass {
            return ScriptSay("A curved toy arrow with a knife attached to it. Brillant!")
        }
        ScriptSay("It has a peculiar curved shape")
    }
}

extension ArcadePlant {
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

extension EarnedTickets {
    
    var inventoryImage: String {
        if RevisorYack.gotGoldenBall { return "EarnedTickets" }
        if Self.gotTicketBoxOnes { return "EarnedTickets4" }
        if RevisorYack.gotMultiuseKnife { return "EarnedTickets" }
        if Self.gotBowlingOnes && Self.gotTinyShooterOnes { return "EarnedTickets3" }
        if Self.gotBowlingOnes || Self.gotTinyShooterOnes { return "EarnedTickets2" }
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
            Animate(actor: display, "count", ms:0, sound:"count_tickets_start")
            if !RevisorYack.hasBeenDistracted {
                Face(.front)
                Say("Greeat, he's distracted! Now'd be the time to do something really clever!")
                SetTrue(&RevisorYack.hasBeenDistracted)
                Face(.left)
            }
            PlaySound("count_tickets_loop")
            PauseScriptWhilePlayerCanDoThings(ms: 10000)
            Walk(to: revisor)
            Animate(actor:display, Self.howManyDoesCryptoHave(), ms:0)
            Animate(actor:revisor, "stop-count-tickets", ms:1200, sound:"count_tickets_end")
            Say(actor: revisor, "Got it")
            Animate("pickup")
            Say(actor:revisor, "There are...")
            Say(actor:revisor, Self.howManyDoesCryptoHave() + " tickets")
            Animate(actor:display, nil)
        }) {
            RevisorYack.isNotLooking = false
        }
    }
    
    override func onLookedAt() {
        ScriptSay("Maybe I can give them to the vendor, so he can count how many I have?")
    }
    
    static func howManyDoesCryptoHave() -> String {
        if RevisorYack.gotGoldenBall { return "05" }
        if Self.gotTicketBoxOnes { return "plain" }
        if RevisorYack.gotMultiuseKnife { return "05" }
        if Self.gotBowlingOnes && Self.gotTinyShooterOnes { return "50" }
        if Self.gotBowlingOnes || Self.gotTinyShooterOnes { return "25" }
        return "0"
    }
}

extension TinyHeroArcade {
    var voiceType: VoiceType { .machine }
    
    var talkPosition: Vector2 { Vector2(x:self.position.x, y: self.position.y + 100 * Float(Game.shared.scale)) }
    
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

extension NoLightersSign {
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("It says...")
            Say("... The use of lighters inside the Arcade Palace is strictly forbidden.")
            SetTrue(&Self.read)
            Autosave()
        }
    }
}


extension HiddenCoffeeCup {
    override func shouldBeAddedToRoom() -> Bool {
        !CoffeeCup.gotHiddenOne
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Say("Come on, I won't put my hand down there! There might be bugs...or rats...or both!")
            SetTrue(&Self.triedSomething)
            Autosave()
        }
    }
    
    override func onLookedAt() {
        Script {
            Walk(to: self)
            Say("Looks like there's something interesting down there, but it's too dark...")
            SetTrue(&Self.triedSomething)
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

extension Sand {
    var inventoryImage: String {
        if Self.isWhiteRabbit { return "SandRabbitWhite" }
        if Self.isRabbit { return "SandRabbit" }
        if Self.isMud { return "PotteryClay "}
        return "Sand"
    }
    
    override var name: String {
        if Self.isWhiteRabbit { return "White mud rabbit" }
        if Self.isRabbit { return "Mud rabbit" }
        if Self.isMud { return "Art mud" }
        return "Sand"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Cocktail.self, Rabbit.self, WhiteBallsBox.self]
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let cocktail = object as? Cocktail{
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
        if !Self.isMud{
            return ScriptSay("Nah...")
        }
        if !Self.isRabbit {
            Script {
                Walk(to:rabbit)
                Say("I can replicate it!")
                Combine(self, losing: nil, settingTrue: &Self.isRabbit) {}
            }
            return
        }
        if !Self.isWhiteRabbit {
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
        if Self.isWhiteRabbit {
            return ScriptSay("I think it's white enough")
        }
        if Self.isRabbit {
            Script {
                Walk(to: box)
                Animate("pickup-low", sound:"use_rabbit_with_balls")
                SetTrue(&Self.isWhiteRabbit)
                ReloadInventory(self)
                Say("A white rabbit!")
            }
            return
        }
        ScriptSay("Why would I put it here?")
    }
    
    override func onLookedAt() {
        if Self.isWhiteRabbit {
            return ScriptSay("A white rabbit made of clay.")
        }
        if Self.isRabbit {
            return ScriptSay("A clay rabbit")
        }
        if Self.isMud {
            return ScriptSay("It's clay! I can replicate anything I see with it!")
        }
        ScriptSay("Plain sand from the punching bag")
    }
}

extension TrapDoor : Animable {
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        if PunchMachine.hasGoldenPunchBag {
            node?.position = node!.position + Vector2(x: 50, y:80) * Game.shared.scale
            node?.scale = Vector2(value: 0.6)
        }
    }
    
    func animate(_ animation: String?) {
        
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

extension ArcadeToBasementDoor {
    
    func shouldChangeToRoom(then:@escaping(_ shouldChange:Bool)->Void) {
        then(PunchMachine.hasGoldenPunchBag)
    }
}

/*extension Smash00 {
    override func isTouched(point: CGPoint) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        node?.run(.repeatForever(.animate(with: [
            texture("smash00"), texture("smash01"),
        ], timePerFrame: 0.3)))
    }
}

extension Tinyshooter00 {
    //override func isTouched(point: CGPoint) -> Bool { false }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        node?.run(.repeatForever(.animate(with: [
            texture("tinyshooter00"), texture("tinyshooter01"),
        ], timePerFrame: 0.25)))
    }
}

extension Figther00 {
    override func isTouched(point: CGPoint) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
    
    override func addToRoom(_ room: Room) {
        super.addToRoom(room)
        node?.run(.repeatForever(.animate(with: [
            texture("figther00"), texture("fighter01"),
        ], timePerFrame: 0.35)))
    }
}*/

extension ArcadeTickets {
    
    static var show:Bool = false
    
    override func shouldBeAddedToRoom() -> Bool {
        Self.show
    }
}

extension ChangeMachine {
    
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

extension MaxKid {
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

