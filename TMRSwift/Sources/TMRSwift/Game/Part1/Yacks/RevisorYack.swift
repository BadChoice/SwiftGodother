import Foundation

class RevisorYack : Yack {
    
    @StateWrapper("entered", object:RevisorYack.self)
    static var entered:Bool
    
    @StateWrapper("canGoIn", object:RevisorYack.self)
    static var canGoIn:Bool
    
    @StateWrapper("gotMultiuseKnife", object:RevisorYack.self)
    static var gotMultiuseKnife:Bool
    
    @StateWrapper("gotGoldenBall", object:RevisorYack.self)
    static var gotGoldenBall:Bool
    
    @StateWrapper("hasBeenDistracted", object:RevisorYack.self)
    static var hasBeenDistracted:Bool
    
    static var isNotLooking:Bool = false
    static var isStealingTickets:Bool = false
    
    let revisor:Revisor
    
    init(_ revisor:Revisor? = nil) {
        self.revisor = revisor ?? roomObject(Revisor.self)!
    }
    
    override func start() -> Section? {
        if Self.canGoIn {
            return ticketsPrizes()
        }
        
        return Section ({
            if !Self.entered {
                SetTrue(&Self.entered)
                /*Say("Wha-? Too young? Can't you see I'm grown up? Here, what do you think this is on my face?", expression: .suspicious)
                Say(actor: revisor, "Looks like chocolate stains to me.")
                Say("That's a beard", expression: .bored, armsExpression:.bored)
                Say(actor:revisor, "Yeah, and I'm the pope")
                Say("And my voice is deep and totally manly!", armsExpression:.explain)
                Say(actor: revisor, "Your what?")
                Say("I said my voice is deep and -", expression: .focus)
                Say(actor: revisor, "Speak up, kid!")
                Say("Oh, forget it", expression: .bored)
                Say(actor: revisor, "You can't fool me, half-pint! I have the ears of an eagle and the eyes of a fox. Or was it the other way around?")
                Say("Yeah, I see: both as sharp as a brick.", expression:.suspicious, armsExpression:.bored)
                Say(actor:revisor, "Get your mom or dad. You can't get in here without an adult!")
                Face(.front)*/
                Say("Musk it. Okay, I'll have to somehow sneak past the old eagle ear...", expression: .angry)
                Face(.left)
            }
        }).options {
            Option("I promise I won't play any machine", expression: .sad, [.once], next: { [unowned self] in
                Section ({
                    Say(actor: revisor, "I don't care, rules are that only grown-ups can go in", expression: .angry)
                    Say(actor: revisor, "Or minors with adult supervision")
                }).next(start)
            })
            Option("I can show you my ID", [.once], next: { [unowned self] in
                Section({
                    Say(actor: revisor, "Umm... I can't see it very well, it might be a fake", expression: .sad)
                    Say(actor: revisor, "Come back with a guardian")
                }).next(start)
            })
            Option("Can I win any of these prizes?", next: { [unowned self] in
                Section({
                    Say(actor: revisor, "Sure, once you're inside, you can win tickets")
                    Say(actor: revisor, "Each prize requires a different amount of tickets")
                    Say("Sounds very interesting")
                }).next(start)
            })
            Option("Nevermind...", next: finish)
        }
    }
    
    func ticketsPrizes() -> Section {
        Section().options {
            Option("How can I earn those tickets?", next:{ [unowned self] in
                Section({
                    Say(actor:revisor, "That's easy, just spend money on the machines")
                    Say(actor:revisor, "And you will get tickets worth a quarter of the money you use.")
                    Say("Man, I'm in the wrong business!", expression: .bored)
                })
            })
            Option("What can the multi-purpose knife do?", next:{ [unowned self] in
                Section ({
                    Say(actor: revisor, "Well, if you wanna cut, slice, saw...")
                    Say(actor: revisor, "...screw, carve, engrave, get dirt out from under your nails...")
                    Say(actor: revisor, "split, divide, scrape, scratch or trim")
                    Say(actor: revisor, "the multi tool knife will serve you well!")
                    Say("Awesome!", expression: .star)
                    Say("Can I make calls with it?", expression: .focus)
                    Say(actor: revisor, "No, not with this one")
                }).next(ticketsPrizes)
            })
            Option("How much for the multi-purpose knife?", shouldShow: !Self.gotMultiuseKnife, next:{ [unowned self] in
                Section {
                    Say(actor: revisor, "45 Tickets")
                }.next(ticketsPrizes)
            })
            Option("How much for these minions?", [.once], next:{ [unowned self] in
                Section ({
                    Say(actor: revisor, "I don't have any minions.")
                    Say("I meant the cuddly little fellas from the famous 'Despicable Me' franchi...oh, nevermind.", armsExpression:.explain)
                }).next(ticketsPrizes)
            })
            Option("How much for the rabbit?", next:{ [unowned self] in
                Section {
                    Say(actor: revisor, "I'm sorry, but the rabbit's for marketing purposes only.")
                }.next(ticketsPrizes)
            })
            Option("How much for the golden bowling ball?", shouldShow: !Self.gotGoldenBall, next:{ [unowned self] in
                Section {
                    Say(actor: revisor, "It costs a ridiculous amount of tickets that you will never, ever have!")
                }.next(ticketsPrizes)
            })
            Option("I'd like the multi-purpose knife, please!", shouldShow: !Self.gotMultiuseKnife, next:getMultiuseKnife)
            Option("I'd like to have the golden bowling ball, please!", shouldShow: !Self.gotGoldenBall, next:getGoldenBall)
            Option("Nevermind...", next: finish)
        }
    }
    
    func getMultiuseKnife() -> Section {
        let knife = MultiUseKnife()
        return Section ({ [unowned self] in
            Say(actor: revisor, "Do you have enough tickets?")
            if false {
                Say("Yessir! Here!", expression: .happy1)
                SetTrue(&RevisorYack.gotMultiuseKnife)
                //ReloadInventory(EarnedTickets())
                Animate("pickup")
                Pickup(knife)
                RemoveFromRoom(knife)
                Autosave()
            } else {
                Say("I don't have enough tickets yet...", armsExpression:.shy)
                Say(actor: revisor, "You can't have the knife if you don't have enough tickets")
            }
        }).next(start)
    }
    
    func getGoldenBall() -> Section {
        let ball = BowlingBall()
        return Section ({ [unowned self] in
            Say(actor: revisor, "You'll need a ridiculous amount of tickets for that. I don't think you will ever get them.")
            if false {
                Say("Sorry to disappoint you, but as it turns out, I DO HAVE THEM!", expression: .happy1, armsExpression:.fist)
                Say(actor: revisor, "WHAT?!", expression:.surprise)
                Say(actor: revisor, "But that's impossible! How did you get them all?", expression:.surprise)
                Say("It wasn't easy, it took years and years of hard work", expression: .bored, armsExpression:.explain)
                Say(actor: revisor, "Okay, I must admit, you surprised me there, kid.")
                Say(actor: revisor, "Have fun!")
                Animate("pickup")
                SetTrue(&RevisorYack.gotGoldenBall)
                //ReloadInventory(EarnedTickets())
                Pickup(ball)
                PlaySound("take_golden_ball")
                RemoveFromRoom(ball)
                Say("Thank you, intend to!")
                Autosave()
            } else {
                Say("I don't have enough tickets yet...", armsExpression:.shy)
                Say(actor: revisor, "You can't have the golden bowling ball if you don't have enough tickets")
            }
        }).next(finish)
    }
}
