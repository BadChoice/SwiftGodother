import SwiftGodot

protocol Talks {
    var talkColor:Color { get }
    var talkPosition:Vector2 { get }
    //var voices:[String:(String, Double)]? { get }
    //var voiceType:VoiceType { get }
    
    func animate(_ animation:String?)
    func setExpression(_ expression:Expression?)
    func setArmsExpression(_ expression:ArmsExpression?)
}

extension Talks {
    func animate(_ animation: String?) {}
    func setExpression(_ expression:Expression?) {}
    func setArmsExpression(_ expression:ArmsExpression?) {}
    var voices:[String:(String, Double)]? { nil }
}


class TalkEngine {
 
    var background:ColorRect!
    var label:Label!
    var then:(()->Void)?
    var actor:Talks?
    //var voiceOver = VoiceOverReal()
    //var voiceOver = VoiceOverTextToSpeach()

    var talkable:Talks {
        (actor ?? Game.shared.room.actor)
    }
    
    func say(scene:MainScene, actor:Talks?, text:String, expression:Expression? = nil, armsExpression:ArmsExpression? = nil, then:@escaping()->Void) {
        
        background?.modulate.alpha = 0
        
        var text = __(text)
        if text.count == 0 { text = " " }
        
        if label != nil {
            //TODO: remove actions
            label.removeAllActions()
            label.removeFromParent()
        }
        
        self.then = then
        self.actor = actor
        
        label = labelWith(text: text, color: talkable.talkColor)
        scene.addChild(node: label)
        label.setPosition(
            getTextPosition(scene, 
                labelWidth: label.getRect().size.x,
                labelHeight: label.getRect().size.y
           )
        )
        background = backgroundWith(label: label)
        scene.addChild(node: background)
                
        talkable.animate("talk")
        talkable.setExpression(expression)
        talkable.setArmsExpression(armsExpression)
        

        //guard Constants.voiceOvers, voiceOver.canPlay(talkable: talkable, text: text) else {
            return showText(text)
        //}
        
        //playVoice(text)
    }

    fileprivate func showText(_ text: String) {        
        background.show()
        label.show()
        
        background.modulate.alpha = 0.4
        label.modulate.alpha = 0.4
        
        background.run(.sequence([
            .fadeAlpha(to: Constants.talkBackgroundAlpha, duration: 0.1),
            .wait(forDuration: textDuration(text)),
            .fadeOut(withDuration: 0.1),
        ]))
        label.run(.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: textDuration(text)),
    //      .fadeOut(withDuration: 0.1),
        ]), completion:{ [unowned self] in
            onPhraseEnded()
        })
    }
    
    /*fileprivate func playVoice(_ text: String) {
        background.run(.fadeAlpha(to: Constants.talkBackgroundAlpha, duration: 0.1))
        label.run(.fadeIn(withDuration: 0.1))
        
        playVoiceOver(text) { [unowned self] in
            background?.run(.fadeOut(withDuration: 0.1))
            label?.run(.fadeOut(withDuration: 0.1)){ [unowned self] in
                onPhraseEnded()
            }
        }
    }
    
    func playVoiceOver(_ text:String, then:@escaping()->Void) {
        voiceOver.play(talkable: talkable, text: text) {
            then()
        }
    }*/
    
    func getTextPosition(_ scene:MainScene, labelWidth:Float, labelHeight:Float) -> Vector2 {
        let talkPoint = talkable.talkPosition
        
        var margin     = Vector2(x:200, y:200) * Game.shared.scale
        var labelSize  = Vector2(x:labelWidth, y: labelHeight)
        let scenePoint = Game.shared.safePosition(talkPoint, size: labelSize + margin) - labelSize / 2
        
        return scenePoint
    }
    
    func labelWith(text:String, color:Color) -> Label {
        let label       = setupLabel()
        
        let lines           = text.splitedByLineLenght(Constants.lineWordLength)
        label.text          = lines.joined(separator: "\n")
        //label.numberOfLines = lines.count
        label.modulate.alpha = 0
        
        label.labelSettings?.fontColor = color
        return label
    }
    
    func backgroundWith(label:Label) -> ColorRect {
        let bg = ColorRect()
       
        let rect = label.getRect().insetBy(dx: -15 * Float(Game.shared.scale), dy: -10 * Float(Game.shared.scale))
        
        bg.setPosition(rect.position)
        bg.setSize(rect.size)
        
        let style = StyleBoxFlat()
        style.cornerRadiusTopLeft = 60
        bg.addThemeStyleboxOverride(name: "panel", stylebox: style)
        
        bg.color = .black
        bg.modulate.alpha = 0
        bg.zIndex = Constants.talk_zIndex - 1
        return bg
    }
    
    func textDuration(_ text:String) -> Double {
        if !Constants.useWordTiming {
            return max(1, Double(text.count) * Constants.charTime)
        }
        return max(1, Double(text.components(separatedBy: " ").count) * Constants.wordTime)
    }
    
    func skip(){
        guard label != nil else { return }
        //label?.removeAllActions()
        onPhraseEnded()
    }
    
    func onPhraseEnded(){
        //voiceOver.stop()
        label?.removeFromParent()
        background?.removeFromParent()
        talkable.animate(nil)
        actor = nil
        label = nil
        then?()
        //then = nil
    }
    
    private func setupLabel() -> Label{
        let label = Label()
        //label.horizontalAlignment = .center
        label.labelSettings = Label.settings()
        label.zIndex = Constants.talk_zIndex
        return label
    }
}
