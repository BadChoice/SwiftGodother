import Foundation

struct Say : CompletableAction {
    
    let text:String
    let actor:Talks?
    let sound:String?
    let expression:Expression?
    let armsExpression:ArmsExpression?
    
    init(actor:Talks? = nil, _ text:String, expression:Expression? = nil, armsExpression:ArmsExpression? = nil, sound:String? = nil){
        self.actor = actor
        self.text = text
        self.sound = sound
        self.expression = expression
        self.armsExpression = armsExpression
    }
    
    init(actor:Talks? = nil, random:[String], expression:Expression? = nil, armsExpression:ArmsExpression? = nil, sound:String? = nil){
        text = random.shuffled().first ?? "..."
        self.actor = actor
        self.sound = sound
        self.expression = expression
        self.armsExpression = armsExpression
    }
        
    func run(then:@escaping()->Void) {
        Sound.play(once: sound)
        Game.shared.talkEngine.say(scene: Game.shared.scene, actor: actor, text: text, expression:expression, armsExpression: armsExpression, then: then)
    }
}

/*
 * Do not use or find missing translations script, doesn't find the phrases
 *
 extension Talks {
    func say(_ text:String, expression:Actor.Expression? = nil, armsExpression:Actor.ArmsExpression? = nil, sound:String? = nil) -> Say {
        
        Say(actor:self, text, expression: expression, armsExpression: armsExpression, sound: sound)
    }
    
    func say(random:[String], expression:Actor.Expression? = nil, armsExpression:Actor.ArmsExpression? = nil, sound:String? = nil) -> Say {
        
        Say(actor:self, random:random, expression: expression, armsExpression: armsExpression, sound: sound)
    }
}
*/

