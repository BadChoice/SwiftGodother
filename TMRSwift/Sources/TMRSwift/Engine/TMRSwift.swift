import SwiftGodot

let allNodes: [Wrapped.Type] = [
    MainScene.self,
    Circle2D.self,    
]

#initSwiftExtension(cdecl: "swift_entry_point", types: allNodes)
