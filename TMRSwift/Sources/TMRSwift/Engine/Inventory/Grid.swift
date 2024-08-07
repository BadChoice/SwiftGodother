import SwiftGodot

class Grid  {
    let rows = 3
    let cols = 4
    
    var page = 0
    
    var node = Node2D()
    
    var arrowUp:Sprite2D?
    var arrowDown:Sprite2D?
    
    
    func showObjectsForCurrentPage(_ objects:[InventoryObject]){
        
        page = max(0, min((objects.count / cols) - 1 , page)) //In case we lost the last object
        arrowVisibility(objectsCount: objects.count)
        
        var i:Float        = 0
        var j:Float        = 0
        let initialX:Float = Float(-320 * Game.shared.scale)
        let initialY:Float = Float(-190 * Game.shared.scale)
        let xSpacing:Float = Float(200 * Game.shared.scale)
        let ySpacing:Float = Float(-200 * Game.shared.scale)
        
        node.removeAllChildren()
        
        clamp(objects:objects).chunked(into: cols).forEach { row in
            row.forEach { object in
                object.createSprite()
                node.addChild(node: object.sprite)
                object.sprite.run(
                    .move(
                        to: Vector2(x: initialX + i * xSpacing, y: initialY - j * ySpacing),
                        duration: 0
                    )
                ) //The move action fixes the bug that sometimes items were not repositionated
                i = i+1
            }
            i = 0
            j = j+1
        }
    }
    
    func shouldShowArrows(count:Int) -> Bool {
        page != 0 || count > (rows * cols)
    }
    
    func clamp(objects:[InventoryObject]) -> [InventoryObject] {
        guard objects.count > 0 else { return [] }
        let start = max(0, page * cols)
        let end   = min(start + (rows * cols), objects.count)
        
        return Array(objects[start...end-1])
    }
        
    func nextPage(_ objects:[InventoryObject]){
        page = min((objects.count / cols) - 1, page + 1)
        showObjectsForCurrentPage(objects)
    }
    
    func prevPage(_ objects:[InventoryObject]){
        page = max(0, page - 1)
        showObjectsForCurrentPage(objects)
    }
    
    //MARK: - Arrows
    func addArrows(node:Node, objectsCount:Int){
        
        guard shouldShowArrows(count: objectsCount) else { return }
                        
        /*arrowUp   = SKSpriteNode(imageNamed: "inventory-arrow")
        arrowDown = SKSpriteNode(imageNamed: "inventory-arrow")
        
        arrowUp!.zIndex   = 2
        arrowDown!.zIndex = 2
        arrowDown?.xScale = -1
        
        arrowUp!.position   = Vector2(x: -200, y: 350) * Game.shared.scale
        arrowDown!.position = Vector2(x: 200,  y: 350) * Game.shared.scale

        node.addChild(arrowUp!)
        node.addChild(arrowDown!)
        
        arrowUp?.shake(duration: 0.5)
        arrowDown?.shake(duration: 0.5)
        */
    }
    
    func arrowVisibility(objectsCount:Int){
        /*arrowDown?.alpha = page == (objectsCount / cols) ? 0 : 1
        arrowUp?.alpha = page == 0 ? 0 : 1
         */
    }
    
    func checkArrowPressed(_ objects:[InventoryObject],at point:Vector2) -> Bool {
        /*if let arrowUp = arrowUp, arrowUp.contains(point){
            prevPage(objects)
            return true
        }
        
        if let arrowDown = arrowDown, arrowDown.parent != nil, arrowDown.contains(point){
            nextPage(objects)
            return true
        }
        return false
         */
        return false
    }
    
}
