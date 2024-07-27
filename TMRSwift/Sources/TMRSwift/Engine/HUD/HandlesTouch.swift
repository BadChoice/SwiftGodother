import SwiftGodot

protocol HandlesTouch {
    func onTouched(at position:Vector2) -> Bool
    func onLongPressed(at position:Vector2) -> Bool
}

protocol HandlesDrag {
    func onMouseMoved(room:Room, at position:Vector2) -> Bool
}
