
import Foundation

extension ArcadeEntrance {
    
    override func onEnter() {
        if ArcadeEntrance.entered { return }
        
        inventory.pickup(ArcadeNote())
        //inventory.pickup(CheatSheet())
        let revisor = roomObject(Revisor.self)!
        let arcadeDoor = roomObject(EntranceToArcadeDoor.self)!
        Script ({
            /*BlackCutScene(fadingIn: false, texts: [
                "DISK 1",
                "The Arcade Palace"
            ])*/
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
            //Talk(yack: RevisorYack(revisor))
            SetTrue(&Self.entered)
        }) {
            //Game.shared.menu.showHowToPlay()
        }
    }
}


extension Balloon {
    
    var inventoryImage: String { Self.painted ? "BalloonFace" : "Balloon" }
    
}
