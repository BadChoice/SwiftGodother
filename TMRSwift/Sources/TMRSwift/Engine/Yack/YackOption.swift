import Foundation
import SwiftGodot

extension Yack {
    class Option {
        let text:String
        let next:(()->Section?)?
        var node:Label!
        
        var expression:Expression?
        var attributes:[Attribute]
        var shouldShow:Bool
        var elseText:String?
        var sound:String?
        
        init(_ text:String, expression:Expression? = nil, _ attributes:[Attribute] = [], saySomethingElse:String? = nil, shouldShow: Bool = true, sound:String? = nil, next:(()->Section?)?){
            self.text       = text
            self.expression = expression
            self.next       = next
            self.attributes = attributes
            self.shouldShow = shouldShow
            self.elseText   = saySomethingElse
            self.sound      = sound
        }
        
        var id : String {
            String(StringName(text).md5Text().prefix(6))            
        }
        
        func markAsSelected(yack:Yack){
            yack.setStateTrue(id)
        }
        
        func wasSelected(yack:Yack) -> Bool{
            yack.isStateTrue(id)
        }
        
        func shouldBeShown(yack:Yack) -> Bool {
            if attributes.contains(.once) && wasSelected(yack: yack) { return false }
            return shouldShow
        }
        
        var speakText: String? {
            if attributes.contains(.noSpeak) { return nil}
            return elseText ?? text
        }
        
        // MODIFIERS ================================================
        func attributes(_ attributes:[Attribute]) -> Self {
            self.attributes = attributes
            return self
        }
        
        func shouldShow(_ shouldShow:Bool) -> Self {
            self.shouldShow = shouldShow
            return self
        }
        
        func saySomethingElse(_ elseText:String) -> Self {
            self.elseText = elseText
            return self
        }
        
        func sound(_ sound:String) -> Self {
            self.sound = sound
            return self
        }
    }
}


@resultBuilder
enum YackOptionBuilder {
    static func buildEither(first component: [Yack.Option]) -> [Yack.Option] {
        component
    }
    
    static func buildEither(second component: [Yack.Option]) -> [Yack.Option] {
        component
    }
    
    static func buildOptional(_ component: [Yack.Option]?) -> [Yack.Option] {
        component ?? []
    }
    
    static func buildBlock(_ components: [Yack.Option]...) -> [Yack.Option] {
        components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: Yack.Option) -> [Yack.Option] {
        [expression]
    }
}
