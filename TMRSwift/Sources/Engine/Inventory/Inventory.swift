import Foundation

class Inventory {
    var objects:[InventoryObject] = []
    
    func pickup(_ object:Inventoriable){
        objects.append(InventoryObject(object))
    }
    
    func lose(_ object:Inventoriable){
        let objectClass = type(of:object)
        objects.removeAll(where: {type(of:$0.object) == objectClass} )
    }
    
    func clear(){
        objects.removeAll()
    }
    
    func contains(_ object:Inventoriable) -> Bool{
        let objectClass = type(of: object)
        return objects.contains {
            type(of:$0.object) == objectClass
        }
    }
    
    func contains(_ object:ObjectScripts) -> Bool {
        guard let inventoriable = object.scriptedObject as? Inventoriable else { return false }
        return inventory.contains(inventoriable)
    }
    
    func load(objects inventoryObjects:[String]){
        objects.removeAll()
        inventoryObjects.forEach {
            let objectType = NSClassFromString(safeClassName($0)) as! Inventoriable.Type
            let object = objectType.init()
            pickup(object)
        }
    }
}
