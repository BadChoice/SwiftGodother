import Foundation

struct WalkToAndSay : CompletableAction {
    
    let object:Object
    let facing:Facing?
    let say:String
    let expression:Expression?
    let armsExpression:ArmsExpression?
    
    init(_ object:Object, facing:Facing? = nil, _ text:String, expression:Expression? = nil, armsExpression:ArmsExpression? = nil){
        self.object = object
        self.facing = facing ?? object.facing
        self.say = text
        self.expression = expression
        self.armsExpression = armsExpression
    }
    
    func run(then: @escaping () -> Void) {
        Script([
            Walk(to: object),
            Say(say, expression: expression, armsExpression:armsExpression),
        ], isSubscript:true, then:then)
    }
    
}
