//
//  StartMenu.swift
//  ProjectHiyoko
//
//  Created by RockBooker on 7/30/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit
import AVFoundation

class StartMenu: SKScene {
    var audio = BGM(bgm: 0)
    var next: SKSpriteNode!

    // 初回起動であるか
    let notFirst = UserData.defaults.boolForKey("NOTFIRST")



    override func didMoveToView(view: SKView) {

        audio.volume = 0.5
        audio.numberOfLoops = -1
        audio.play()

        let title = SKLabelNode(fontNamed: "Menlo Bold")
        title.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        title.zPosition = 10
        title.fontColor = SKColor.blackColor()
        title.fontSize = 30
        title.color = SKColor.whiteColor()
        title.text = "我輩は、ひよこである"
        self.addChild(title)

        let title2 = SKLabelNode(fontNamed: "Menlo Bold")
        title2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        title2.zPosition = 10
        title2.fontColor = SKColor.blackColor()
        title2.fontSize = 30
        title2.color = SKColor.whiteColor()
        title2.text = "名前は、まだない。"
        self.addChild(title2)



        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bg.zPosition = -10
        bg.size = self.size
        self.addChild(bg)

        let hiyoko = SKSpriteNode(imageNamed: "hiyoko1")
        hiyoko.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        hiyoko.zPosition = 0
        self.addChild(hiyoko)

        let texture = SKTexture(imageNamed: "heart")

        let heart1 = SKSpriteNode(texture: texture)
        heart1.position = CGPoint(x: self.size.width*0.6, y: self.size.height*0.6)
        self.addChild(heart1)


        let heart2 = SKSpriteNode(texture: texture)
        heart2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.6)
        self.addChild(heart2)

        let heart3 = SKSpriteNode(texture: texture)
        heart3.position = CGPoint(x: self.size.width*0.4, y: self.size.height*0.6)
        self.addChild(heart3)

        let scaleUp = SKAction.scaleTo(1.5, duration: 1.0)
        let scaleDw = SKAction.scaleTo(1.0, duration: 1.0)
        let scaleUpDown = SKAction.sequence([scaleUp, scaleDw])

        heart1.runAction(SKAction.repeatActionForever(scaleUpDown))
        heart2.runAction(SKAction.repeatActionForever(scaleUpDown))
        heart3.runAction(SKAction.repeatActionForever(scaleUpDown))



        next = SKSpriteNode(imageNamed: "nextButton")
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        next.zPosition = 0
        next.name = "next"
        next.size = CGSize(width: next.size.width*2.0, height: next.size.height*2.0)
        self.addChild(next)
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)

            if self.nodeAtPoint(location).name == "next" {
                audio.stop()

                // 初回起動である
                if notFirst == false {
                    UserData.defaults.setObject(true, forKey: "NOTFIRST")
                    UserData.defaults.synchronize()

                    let click = SKAction.playSoundFileNamed("click", waitForCompletion: true)
                    self.next.runAction(click)

                    let tr = SKTransition.fadeWithDuration(2.0)
                    let newScene = EpilogueScene(size: self.size)
                    newScene.scaleMode = .AspectFill
                    self.scene!.view!.presentScene(newScene, transition: tr)

                } else {
                    let click = SKAction.playSoundFileNamed("click", waitForCompletion: true)
                    self.next.runAction(click)

                    let tr = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
                    let newScene = GameScene(size: self.size)
                    newScene.scaleMode = .AspectFill
                    self.scene!.view!.presentScene(newScene, transition: tr)

                }
            }

        }

    }
}