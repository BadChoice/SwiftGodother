import Foundation

extension Yack {
    struct Section{
        let script:[CompletableAction]?
        let options:[Option]?
        var next:(()->Section?)?
        
        // DSL
        public init(@CompletableActionsBuilder _ builder: () -> [CompletableAction]){
            self.init(builder())
        }
        
        // STANDARD
        init(_ script:[CompletableAction]? = nil, options:[Option]? = nil, next:(()->Section?)? = nil){
            self.script  = script
            self.options = options
            self.next    = next
        }
        
        init(_ script:CompletableAction, options:[Option]? = nil, next:(()->Section?)? = nil){
            self.init([script], options: options, next: next)
        }
        
        // DSL MODIFIERS
        func options(@YackOptionBuilder _ optionsBuilder: () -> [Option]) -> Section {
            Section(self.script, options:optionsBuilder(), next:self.next)
        }
        
        func next(_ next:(()->Section?)? = nil) -> Section {
            Section(self.script, options:self.options, next:next)
        }
        
        func options(_ options:[Option?]) -> Section {
            Section(self.script, options:options.compactMap { $0 }, next:next)
        }
    }
    
}
