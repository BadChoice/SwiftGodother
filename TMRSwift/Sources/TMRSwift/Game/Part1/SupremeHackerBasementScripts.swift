import Foundation

//Music: https://www.storyblocks.com/audio/stock/storytelling-orchestral-mystery-trailer-bodgogsyvkhf5g0u1.html
extension SupremeHackerBasement {
    override func onEnter() {
        node.run(.scale(to: 1.02, duration:1).withTimingMode(.out))
        
        if !Self.entered {
            Self.entered = true
            roomObject(SupremeHacker.self)?.onMouthed()
        }
    }
}

/*extension SupremeHacker {
    override func onMouthed() {
        Script {
            Walk(to: self)
            Talk(yack: SupremeHackerYack(self))
        }
    }
}

extension BasementCoffeeCup {
    
    override func shouldBeAddedToRoom() -> Bool {
        !CoffeeCup.gotBasementOne
    }
    
    override func onUse() {
        Script {
            Walk(to: self)
            Animate("pickup", sound:"take_coffee_cup")
            RemoveFromRoom(self)
            CoffeeCupPicker(which: &CoffeeCup.gotBasementOne)
            Autosave()
        }
    }
}
*/
extension PillBag {
    var inventoryImage: String { Self.isSmashed ? "PillBagSmashed" : "PillBag" }
    
    override var name: String {
        Self.isSmashed ? "Smashed pill bag" : "Pill bag"
    }
    
    override func combinesWith() -> [Object.Type] {
        [Rabbit.self, Ice.self, CarOil.self, SmashHammer.self, SupremeHacker.self]
    }
    
    override func onLookedAt() {
        Script {
            Say("To create the CyberSphere pill I need...")
            Say("rabbit fur")
            Say("crushed ice")
            Say("lubricant")
        }
    }
    
    override func onMouthed() {
        ScriptSay("I'm not doing anything without supervision from the Supreme Hacker")
    }
    
    override func onUse() {
        onMouthed()
    }
    
    override func onUseWith(_ object: Object, reversed:Bool) {
        if let rabbit = object as? Rabbit {
            return useWith(rabbit)
        }
        if let ice = object as? Ice {
            return useWith(ice)
        }
        if let lube = object as? CarOil {
            return useWith(lube)
        }
        if let hammer = object as? SmashHammer {
            return useWith(hammer)
        }
        if let hacker = object as? SupremeHacker {
            return useWith(hacker)
        }
        super.onUseWith(self, reversed:reversed)
    }
    
    func useWith(_ rabbit:Rabbit){
        if !rabbit.inInventory{
            return ScriptSay("I should get my hands on it first")
        }
        Script {
            Combine(self, losing: rabbit, settingTrue: &Self.hasRabbit) { }
            if Self.hasAllIngredients() {
                Face(.front)
                Say("I have them all!")
            }
        }
    }
    
    func useWith(_ ice:Ice){
        Script {
            Combine(self, losing: ice, settingTrue: &Self.hasIce) { }
            if Self.hasAllIngredients() {
                Face(.front)
                Say("I have them all!")
            }
        }
    }
    
    func useWith(_ lube:CarOil){
        if Self.hasLube {
            return ScriptSay("That's enough")
        }
        Script {
            if !lube.inInventory {
               WalkToAndPickup(lube)
            }
            Say("I guess this will count as lubricant")
            Combine(self, losing: lube, settingTrue: &Self.hasLube) { }
            if Self.hasAllIngredients() {
                Face(.front)
                Say("I have them all!")
            }
        }
    }
    
    func useWith(_ hammer:SmashHammer){
        guard Self.hasAllIngredients() else {
            return ScriptSay("Hmm. I still need some more ingredients...")
        }
        Script {
            Walk(to: hammer)
            Animate("pickup")
            //ComicSmashPillBag()
            SetTrue(&Self.isSmashed)
            ReloadInventory(self)
        }
    }
    
    func useWith(_ hacker:SupremeHacker){
        guard Self.hasAllIngredients() else {
            return ScriptSay("Hmm. I still need some more ingredients...")
        }
        
        Script {
            //Talk(yack: SupremeHackerPillYack(hacker))
        }
        
    }
    
    static func hasAllIngredients() -> Bool {
        Self.hasRabbit && Self.hasIce && Self.hasLube
    }
}

/*
extension Oculus {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "A VR headset. Unfortunately, this won't take me to the CyberSphere.")
        }
    }
    
    override func onUse() {
        let hacker = roomObject(SupremeHacker.self)!
        Script {
            Walk(to: self)
            Say(actor: hacker, "Unfortunatley, these won't get you to the REAL Cybersphere. Just bring me the ingredients to make the pill.")
        }
    }
}

extension Tank1{
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Hi there, creepy people, submerged in your spooky glass tanks...")
            Say("I'll soon be one of you!")
        }
    }
}

extension Tank2 {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Hi there, creepy people, submerged in your spooky glass tanks...")
            Say("I'll soon be one of you!")
        }
    }
}

extension SupremeHackerScreen {
    override func onLookedAt() {
        Script {
            WalkToAndSay(self, "Man, he writes absolutely SOLID code!")
        }
    }
    
    override func onPhoned() {
        let hacker = roomObject(SupremeHacker.self)!
        Script {
            Walk(to: self)
            Animate(Crypto.usePhone)
            Say(actor: hacker, "Are you sure you want to try to hack me?", expression: .surprise)
            Say("Wasn't it part of the training?", expression: .suspicious)
            Say(actor: hacker, "You better focus on bringing me the pill ingredients", expression: .angry)
        }
    }
}
*/
