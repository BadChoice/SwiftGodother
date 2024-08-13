import Foundation

class Combine : CompletableAction {
    
    let main:Inventoriable
    let losable:Inventoriable?
    let whenCanCombine:[CompletableAction]?
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    init(_ main:Inventoriable, losing:Inventoriable?, settingTrue state:inout Bool, @CompletableActionsBuilder _ builder: () -> [CompletableAction]?){
        self.main = main
        self.losable = losing
        self.whenCanCombine = builder()
        if canCombine {
            state = true
        }
    }
    
    /**
     Warning, don't call this on a When action statement as it is change automatically, use the if / else result builder approach
     */
    init(_ main:Inventoriable, losing:Inventoriable?, settingFalse state:inout Bool, @CompletableActionsBuilder _ builder: () -> [CompletableAction]?){
        self.main = main
        self.losable = losing
        self.whenCanCombine = builder()
        if canCombine {
            state = false
        }
    }
    
    func run(then: @escaping () -> Void) {
        guard canCombine else {
            Script({
                Say("It would be nice if I had BOTH of them in my inventory")
            }, then:then)
            return
        }
        Game.shared.scene.inventoryUI.hide()
        Script ({
            //Animate(Crypto.combine)
            ReloadInventory(main)
            if let losable = losable {
                Lose(losable, notChanginState: true)
            }
        }, then:{ [unowned self] in
            guard let whenCanCombine else {
                return then()
            }
            Script(whenCanCombine, then:then)
        })
    }
    
    private var canCombine: Bool {
        main.inInventory && (losable?.inInventory ?? true)
    }
}
