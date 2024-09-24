import Foundation

protocol CompletableAction {
    func run(then:@escaping ()->Void)
}

struct Script {
    
    /**
     In case we run Script() inside another Script, we don't want to enable touch until parent one finishes
     */
    var isSubscript:Bool = false
    
    @discardableResult
    public init(@CompletableActionsBuilder _ builder: () -> [CompletableAction], then:(()->Void)? = nil){
        self.init(builder(), then: then)
    }
    
    @discardableResult
    init(_ sequential:[CompletableAction], isSubscript:Bool = false, then:(()->Void)? = nil){
        self.isSubscript = isSubscript
        self.sequential(actions: sequential, then:then)
    }
        
    func sequential(actions:[CompletableAction], then:(()->Void)? = nil){
        guard actions.count > 0 else {
            then?()
            if !isSubscript {
                Game.shared.touchLocked = false
            }
            return
        }
        Game.shared.touchLocked = true
        //Game.shared.screenScanner.hideArrow() //TODO: Reenable
        actions.first!.run {
            sequential(actions: Array(actions[1...]), then:then)
        }
    }
}


//https://theswiftdev.com/result-builders-in-swift/
@resultBuilder
enum CompletableActionsBuilder {
    static func buildEither(first component: [CompletableAction]) -> [CompletableAction] {
        component
    }
    
    static func buildEither(second component: [CompletableAction]) -> [CompletableAction] {
        component
    }
    
    static func buildOptional(_ component: [CompletableAction]?) -> [CompletableAction] {
        component ?? []
    }
    
    static func buildBlock(_ components: [CompletableAction]...) -> [CompletableAction] {
        components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: CompletableAction) -> [CompletableAction] {
        [expression]
    }
}
