import Foundation

class MainteinanceGirlYack : Yack {
    
    @StateWrapper("entered", object:MainteinanceGirlYack.self)
    static var entered:Bool
    
    @StateWrapper("knowsWhatSheIsDoing", object:MainteinanceGirlYack.self)
    static var knowsWhatSheIsDoing:Bool
    
    let leia:MainteinanceGirlScripts
    
    init(leia:MainteinanceGirlScripts){
        self.leia = leia
    }
    
    override func start() -> Section {
        Section ({
            if !Self.entered {
                SetTrue(&Self.entered)
                Say("Hi, I'm Crypto.", armsExpression: .explain)
                Say(actor:leia, "Hi Crypto, I'm Leia.")
                Say("Leia, huh? I bet I can guess your twin brother's name.")
                Say(actor:leia, "I don't have a twin brother.")
                Say("Oops. Anyway: nice to meet you.", expression: .ouch, armsExpression: .shy)
                Face(.front)
                Say("Wow, worst pickup line ever, genius!", expression:.sad)
                Face(.right)
                Say(actor:leia, "Likewise. I assume.")
                Say("So, what you're doing here, Leia?")
                Say(actor:leia, "I'm trying to get this thing working.")
                Say("Um, okay. Soooo... what's it gonna be when it's finished?", armsExpression: .bored)
                Say(actor:leia, "No idea. I'll see when it's done.")
                Say("Huh, interesting. Perhaps I can help somehow?", armsExpression: .shy)
                Say(actor:leia, "Maybe. I need to fuse two cables together, see. Unfortunately, my lighter died on me.")
                SetTrue(&Self.knowsWhatSheIsDoing)
                Say("Sorry, I don't have a lighter on me. I'm a lover, not a smoker. Maybe someone in there has one?", armsExpression: .explain)
                Say(actor:leia, "Forget it. Lighters are forbidden in there.")
            }
        }).options {
            Option("Would you help me go in?",  shouldShow: !RevisorYack.canGoIn,            next:guardian)
            Option("Do you know where can I find the Supreme Hacker?", [.once], shouldShow:RevisorYack.canGoIn && !PunchMachine.hasGoldenPunchBag, next:supremeHacker)
            Option("Any luck with the fire?",   shouldShow: !inventory.contains(Lighter()),  next:whatAreYouDoing)
            Option("That's ok", [.noSpeak], next:finish)
        }
    }
    
    func guardian() -> Section {
        Section ({
            Say("The vendor won't let me. He thinks I'm a minor.", armsExpression: .explain)
            Say(actor: leia, "He doesn't see very well and always gets it wrong")
            Say(actor: leia, "But I need to finish this first, I can't help you right now")
        }).next(start)
    }

    
    func whatAreYouDoing() -> Section {
        Section ({
            Say(actor: leia, "No... the lighter is out of gas, just sparks")
            Say("I'll see if I can help you with something, I'm really good at building stuff", armsExpression: .bored)
        }).next(start)
    }
    
    func supremeHacker() -> Section {
        Section ({ [unowned self] in
            Say(actor: leia, "The supreme what?")
            Say("The Supreme Hacker... a guy who's always playing with computers?", armsExpression: .explain)
            Say(actor: leia, "No idea, everyone that comes here just plays the arcade machines, no computers around")
            Say("And any idea about the code THE STRENGTH IS GOLD?")
            Say(actor: leia, "The only gold thing around is that bowling ball, but you need a ridiculous amount of tickets to get it")
            if RevisorYack.gotGoldenBall {
                Say(actor:leia, "Ohh, I see that it's not there anymore!")
            }
            Say("Thanks... I'll keep looking")
        }).next(start)
    }
}
