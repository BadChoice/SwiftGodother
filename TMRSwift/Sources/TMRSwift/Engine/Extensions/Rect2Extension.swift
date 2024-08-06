import SwiftGodot

extension Rect2 {
    
    func insetBy(dx:Float, dy:Float) -> Rect2 {
        
        var finalRect = Rect2()
        finalRect.size.x = size.x - dx * 2
        finalRect.size.y = size.y - dy * 2
        finalRect.position.x = position.x + dx
        finalRect.position.y = position.y + dy
        
        return finalRect
        
        
    }
    
    //rect: label.getRect()/*.insetBy(dx: -15, dy: -10), cornerRadius: 14)*/
}
