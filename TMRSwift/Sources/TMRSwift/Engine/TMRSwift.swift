import SwiftGodot

let allNodes: [Wrapped.Type] = [
    MainScene.self,
    Player.self,
    Room.self,
]

#initSwiftExtension(cdecl: "swift_entry_point", types: allNodes)
