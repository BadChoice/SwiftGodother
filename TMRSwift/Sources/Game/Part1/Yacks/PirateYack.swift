import Foundation

class PirateYack : Yack {
    
    @StateWrapper("entered", object:PirateYack.self)
    static var entered:Bool
    
    @StateWrapper("toldAboutLighterTrick", object:PirateYack.self)
    static var toldAboutLighterTrick:Bool
    
    @StateWrapper("learnedThatPirateKnowsTheLighterTrick", object:PirateYack.self)
    static var learnedThatPirateKnowsTheLighterTrick:Bool
    
    var enteredTryToLearnTrick  = false
    
    let pirate:PirateScripts
    
    init(_ pirate:PirateScripts){
        self.pirate = pirate
    }
    
    override func start() -> Yack.Section? {
        if !Self.entered {
            return firstTime()
        }
        
        return Section {
            
        }.options {
            Option("You don't happen to know where I can find the real Supreme Hacker, do you?", [.once]) { [unowned self] in
                Section {
                    Say(actor:self.pirate, "Nay. Can't claim that I do. Yer have to keep yer ears to the deck and yer eyes peeled.")
                    Say("Okay dokey. Uh, I mean: yohoho. Or whatever.")
                }.next(start)
            }
            Option("Say, what happened to your eye?", [.once]) {  [unowned self] in
                Section ({
                    Say(actor:pirate, "Arr. What eye, matey?")
                    Say("I thought the eye patch...", expression:.ouch, armsExpression: .shy)
                    Say(actor:pirate, "Avast ye! It's called 'style'. Savvy?", expression:.angry)
                    Say("Occasionally.", expression:.small)
                }).next(start)
            }
            Option("Do you happen to have a used coffee cup?", [.once], shouldShow: ReuseCoffeeCupsPromo.isRead) {  [unowned self] in
                Section ({
                    Say(actor: self.pirate, "I don't drink coffee, it's too weak", expression:.angry)
                }).next(start)
            }
            Option("Word is, there aren't any lighters allowed in this joint. That right?", [.once], next:noLighterSign)
            Option("About that trick...",  shouldShow:Self.learnedThatPirateKnowsTheLighterTrick && !Self.toldAboutLighterTrick, next:tryToLearnTrick)
            Option("That's ok", next:finish)
        }
    }
    
    func firstTime() -> Section {
        Section ({ [unowned self] in
            SetTrue(&Self.entered)
            Say("Oh man, it's really you!", expression: .happy1, armsExpression: .fist)
            Say("I'm actually shaking like jello!", expression: .happy2)
            Say("Let me say what an absolute honor and pleasure it is to finally meet you in person, sir!", armsExpression: .explain)
            Say("I've been looking for you for ages - but here I am! I am your willing vessel! Fill me with as much knowledge as you can!")
            Say(actor:pirate, "Arrh! Don't take it personally, me lad. But are ye three sheets to the wind?", expression:.angry)
            Say("Um, three what to the what now?", expression: .suspicious, armsExpression: .bored)
            Say(actor:pirate, "Are ye a carouser? Had yerself too much o' the good stuff?")
            Say("I'm quite sober. If that's what you're asking.", expression: .bored, armsExpression: .shy)
            Say(actor:pirate, "So who the hell are ye?", expression:.angry)
            Say("Ah, I see! This pirate talk – it's just a test, right?", expression: .happy, armsExpression: .explain)
            Say("Okay, let's see.", armsExpression: .fist)
            Say("Uh – the strength is gold.", expression: .focus, armsExpression: .explain)
            Say(actor:pirate, "Whoever yer searching for, ye got the wrong sailor in front of ye, lad. I'm just an Old Salt who wants to quietly enjoy his rum in this harbor dive before setting sail again.", expression:.sad)
            Say("Ah. sorry my bad", expression: .ouch, armsExpression: .shy)
            Say(actor:pirate, "So - will ye buy me a grog or what?", expression:.angry)
            Say("Sorry, no can do. I need to find the Supreme Hacker.", expression:.suspicious)
            Say(actor:pirate, "Yarr. Whatever floats your boat, lad.", expression:.sad)
        }).next(start)
    }
    
    func noLighterSign() -> Section {
        Section ({
            Say(actor:pirate, "Yarr! They were outlawed a while ago. The young scallywags hereabouts found out that ye could start the arcade machine with a lighter spark and play fer free.")
            Say("Kids these days, amirite? Wonder how they found that out...", armsExpression: .bored)
            Say(actor:pirate, "T'was I who showed them how to hornswaggle the darn thingies.")
            Say("I did not see that coming.", armsExpression: .shy)
            Say(actor:pirate, "That's why I be still sitting here, harhar!")
            SetTrue(&Self.learnedThatPirateKnowsTheLighterTrick)
        }).next(start)
    }
    
    func tryToLearnTrick() -> Section {
        Section({
            if !enteredTryToLearnTrick {
                Say(actor:pirate, "Hurr?")
                Say("Can you teach me how to do it?", expression: .suspicious, armsExpression: .shy)
                Say(actor:pirate, "Not so fast, laddie! First ye must tell me: what do ye want to meet this hacker character so badly for?", expression:.angry)
                Say("Um, to become an elite hacker. Isn't that obvious?", expression:.bored, armsExpression: .explain)
                Say(actor:pirate, "Yarr. But what do ye intend to do with all them hacker skills ye wish to learn?")
                Say("Okay,")
                Say("I'll tell you. I want to...", armsExpression: .explain)
                SetTrue(&enteredTryToLearnTrick)
            }
        }).options({
            Option("...get rich and famous!", [.noSpeak, .once], next:richAndFamous)
            Option("...create some beautiful chaos!", [.noSpeak, .once], next:createChaos)
            Option("...make the world a safer place!", [.noSpeak], next:betterWorld)
        })
    }
    
    func richAndFamous() -> Section {
        Section({
            Say("... hack my way to wealth and fame! What else?", armsExpression: .fist)
            Say(actor:pirate, "Arrh, but money'n fame be not everything, mate!", expression:.angry)
            Say(actor:pirate, "Take me f'r instance: I used to be a famous underwear model. And what good did it do me?")
            Say("...", expression:.small)
            Say("You serious?", expression:.small, armsExpression: .bored)
            Say(actor:pirate, "Course not, ye scabby sea bass!", expression:.angry)
            Say("Um, yeah, me neither.", expression:.bored, armsExpression: .explain)
            Say("See, the real reason is I want to...")
        }).next(tryToLearnTrick)
    }
    
    func createChaos() -> Section {
        Section({
            Say("... create some sweet, sweet chaos! Throw some sand in the gears of the high and mighty, dig it?", armsExpression: .fist)
            Say("expose some corrupt politicians, bring some mega corporations to their knees.")
            Say("You know.", armsExpression: .explain)
            Say("That kinda stuff")
            Say(actor:pirate, "Arrh! Ye disappoint me, lad!", expression: .sad)
            Say(actor:pirate, "Peel yer peepers")
            Say(actor:pirate, "there be enough madness'n mayhem in the world already!", expression: .sad)
            Say(actor:pirate, "If that be yer real reason, ye won't get one more word from me about anything!", expression:.angry)
            Say("Oops.", expression: .ouch, armsExpression: .shy)
            Say("C'mon man, you know I was just joking, right?", expression: .happy)
            Say("Right??", expression: .small, armsExpression: .explain)
            Say(actor:pirate, "Were ye now?")
            Say("Of course! There's only one reason I wanna become an elite hacker. And that's to...")
        }).next(tryToLearnTrick)
    }
    
    func betterWorld() -> Section {
        Section ({
            Say("...make the world a safer place.", expression: .happy, armsExpression: .fist)
            Say("... protect the common people from all the BAD hackers out there. You know", armsExpression: .explain)
            Say("the scammers and phishers and grifters.", expression: .angry, armsExpression: .fist)
            Say("You know: all those bastards who take something awesome like the internet and use it to suck the money from other people's pockets.", expression: .angry)
            Say("If I'm an elite hacker, I'll give them a taste of their own medicine.", expression: .angry, armsExpression: .explain)
            Say("Um, metaphorically speaking.", armsExpression: .shy)
            Say(actor:pirate, "Hrrr.", expression: .angry)
            Say(actor:pirate, "That so?", expression: .angry)
            Say("Swear on my goldfish's grave!")
            Say(actor:pirate, "Arrh, laddie, then mayhaps there be some hope left for the youth of this world!")
            Say("So... you'll teach me the trick?", expression: .happy, armsExpression: .explain)
            Say(actor:pirate, "Aye, I will teach it to ye!")
            Say(actor:pirate, "But ye must swear on Davy Jones' locker never to tell anyone. Ye hear?")
            Say("I swear", armsExpression: .fist)
            Say("On Davy Jones's locker and any other furniture involved!", expression: .suspicious, armsExpression: .bored)
            Say(actor:pirate, "So listen up, matey. I'm only gonna tell yer once!", expression: .angry)
            Say(actor:pirate, "*whisper* *whisper*")
            Say("Ahaa")
            Say(actor:pirate, "*whisper* *whisper*")
            Say("Wow, that's brilliant!", expression: .happy1, armsExpression: .explain)
            Say(actor:pirate, "Ain't it so?")
            Say(actor:pirate, "Now clear the deck, bucko, and heave ho!")
            Say("Aye, aye, cap'n!", expression: .focus)
            SetTrue(&Self.toldAboutLighterTrick)
        }).next(finish)
    }
    
}

