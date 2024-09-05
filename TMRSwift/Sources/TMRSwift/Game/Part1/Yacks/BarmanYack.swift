import Foundation

class BarmanYack : Yack {
    
    let barman:Barman
    var entered:Bool = false
    
    @StateWrapper("knowsAboutCocktailGrownUp", object:BarmanYack.self)
    static var knowsAboutCocktailGrownUp:Bool
    
    init(_ barman:Barman){
        self.barman = barman
    }
    
    override func start() -> Yack.Section? {
        Section ({
            if !entered {
                
                Say(actor: barman, "Hello and welcome, young sir")
                Say(actor: barman, "How can I help you on this fine day?")
                Say(actor: barman, "Are you perhaps interested in our Caramel Banana Marshmallow Latte Macciato with cinnamon and chocolate sprinkles on top...")
                Say(actor: barman, "... or do you prefer a delicious donut with a yummy cherry/apricot jam filling and scrumptious slivers of candied almonds?", expression:.suspicious)
                Say(actor: barman, "A real treat for the palate.")
                Say("Sounds tempting. And not unhealthy at all. But maybe later.", armsExpression: .shy)
                Say(actor: barman, "As you wish, my good sir.")
                Face(.front)
                Say("Man, more people should call me sir!")
                Face(.left)
                Say("Um, one question...")
                Say("You wouldn't happen to know where I can find the Supreme Hacker?", expression:.suspicious, armsExpression: .explain)
                Say(actor: barman, "Alas, I cannot claim to be of any help in this regard, as much as it pains me.", expression:.sad)
                Say(actor: barman, "Many young gentlefolk have been drawn here in search of this mysterious individual, but I am afraid they all have fallen victim to a hoax from the World Wide Web.", expression: .sad)
                Say("No, he's real!", armsExpression: .fist)
                Say(actor: barman, "Are you sure of that, sir?")
                Say("90%!", armsExpression: .shy)
                Say("Well, 80 ...", expression:.focus, armsExpression: .explain)
                Say("Okay, definitely something over 60%!", expression:.suspicious, armsExpression: .shy)
                Say(actor: barman, "I understand.")
                Say(actor: barman, "Mayhaps you should make the acquaintance of the elderly gentleman at the table yonder.")
                Say(actor: barman, "He's a frequent customer. He might know more about this affair than I do.")
                Say(actor: barman, "If not, maybe he can at least entertain you with one of his delightful stories about his past adventures.", expression:.sad)
                Say(actor: barman, "Might there be anything else you might want to know, good sir?")
                Say("Yes! How did you learn to talk this fancy?")
                Say(actor: barman, "I happen to read a lot.", expression:.happy)
                Say(actor: barman, "Only the literary giants: Chaucer, Shakespeare, Barbara Cartwright. Mickey Mouse.", expression:.suspicious)
                Say("That explains A LOT.", expression: .suspicious, armsExpression: .explain)
                SetTrue(&self.entered)
            }
        }).options ({
            Option("I'd like to get a cocktail", shouldShow: !inventory.contains(Cocktail())){  [unowned self] in
                Section ({
                    Say(actor: self.barman, "Sorry, but we don't serve cocktails to minors", expression:.sad)
                    Say("You too? I'm an adult...", expression: .bored, armsExpression: .bored)
                    Say(actor: self.barman, "BUT!...")
                    Say(actor: self.barman, "Then this is your lucky day! We have a special offer!")
                    Say(actor: self.barman, "Bring me 4 used coffee cups and you get a free cocktail!")
                    Say(actor: self.barman, "Irresistible offer")
                    Say("Won't I be still be a minor?", expression: .bored, armsExpression: .bored)
                    Say(actor: self.barman, "The offer does not specify anything in that regard, so this is your only chance")
                    SetTrue(&ReuseCoffeeCupsPromo.isRead)
                    SetTrue(&Self.knowsAboutCocktailGrownUp)
                }).next(start)
            }
            Option("I'd like to get a coffee", shouldShow: !CoffeeCup.gotBarOne){ [unowned self] in
                Section ({
                    Say(actor:self.barman, "Since you are new here, I can make you one for free!")
                    Say("Sure, why not?", expression: .love)
                    Animate("pickup", sound:"take_coffee_cup")
                    Animate(Crypto.handToMouth)
                    Say("Ahhh! There's nothing like a freshly brewed coffee!", expression: .happy2, armsExpression: .explain)
                    CoffeeCupPicker(which: &CoffeeCup.gotBarOne)
                    Autosave()
                }).next(start)
            }
            Option("I'll come back later") { [unowned self] in
                Section {
                    Say(actor: barman, "I'm not moving")
                }.next(finish)
            }
        })
    }
}
