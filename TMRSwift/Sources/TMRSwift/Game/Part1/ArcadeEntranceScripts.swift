
import Foundation
import SwiftGodot

extension ArcadeEntrance {
    
    override func onEnter() {
        if ArcadeEntrance.entered { return }
                
        inventory.pickup(ArcadeNote())
        //inventory.pickup(CheatSheet())
        let revisor = roomObject(Revisor.self)!
        let arcadeDoor = roomObject(EntranceToArcadeDoor.self)!
        
        Game.shared.actor.node.position = Vector2(x:400, y:400)
        
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


extension ArcadeNote {
    override func onLookedAt() {
        Script {
            Say("It says...")
            Say(">> Come to the palace to become an elite hacker, and remember that the strength is gold <<")
        }
    }
}

extension Balloon {
        
    var inventoryImage: String { Self.painted ? "BalloonFace" : "Balloon" }
    
    override func combinesWith() -> [Object.Type] {
        [CarOil.self, Revisor.self/*, Barman.self*/]
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
        /*if let barman = object as? Barman{
            return useWith(barman)
        }*/
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
            //SetTrue(&RevisorYack.canGoIn)
            //Autosave()
            //GoThroughDoor(door)
        }
    }
        
    /*func useWith(_ barman:Barman){
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
    }*/
    
    override func onLookedAt() {
        if Self.painted {
            return ScriptSay("A happy balloon")
        }
        return ScriptSay("A lonely balloon")
    }
}

extension VanFront {
    override var zIndex: Int32 { 5 }
    //override func isTouched(at: Vector2) -> Bool { false }
    override var showItsHotspotHint:Bool { false }
}

extension CarOil {
    override func combinesWith() -> [Object.Type] {
        [Balloon.self/*, PillBag.self*/]
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
        /*if let pill = object as? PillBag {
            return pill.useWith(self)
        }*/
        
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
            /*Combine(balloon, losing: self, settingTrue: &Balloon.painted){
                Autosave()
                Say("Man, hacker AND artist – I'm a whizz-kid!")
            }*/
        }
    }
}
