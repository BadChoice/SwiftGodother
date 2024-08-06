import SwiftGodot

let allNodes: [Wrapped.Type] = [
    MainScene.self,    
]

#initSwiftExtension(cdecl: "swift_entry_point", types: allNodes)
