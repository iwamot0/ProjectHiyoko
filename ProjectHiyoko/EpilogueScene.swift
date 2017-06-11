//
//  EpilogueScene.swift
//  ProjectHiyoko
//
//  Created by RockBooker on 7/30/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit
import AVFoundation


class EpilogueScene: SKScene {

    var i: Int = 1
    var c: Int = 0

    var window: SKSpriteNode!
    var next: SKSpriteNode!

    var audio = BGM(bgm: 2)

    override func didMoveToView(view: SKView) {
        audio.volume = 0.5
        audio.numberOfLoops = -1
        audio.play()

        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bg.size = self.size
        bg.zPosition = -10
        self.addChild(bg)

        let hiyoko = SKSpriteNode(imageNamed: "hiyoko0")
        hiyoko.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        hiyoko.zPosition = 0
        hiyoko.size = CGSize(width: hiyoko.size.width*2.0, height: hiyoko.size.height*2.0)
        self.addChild(hiyoko)

        next = SKSpriteNode(imageNamed: "nextButton")
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        next.zPosition = 10
        next.size = CGSize(width: next.size.width*2.0, height: next.size.height*2.0)
        next.name = "next"
        self.addChild(next)

        setEpilogue("epi\(i)")


    }


    override func update(currentTime: NSTimeInterval) {

          // そうでなければ、次へボタンが押されるたびにウィンドウを切り替えて物語を語る
        if i != 6 && i == c {
            window.removeFromParent()
            i += 1
            setEpilogue("epi\(i)")

        }

        if c == 6 {
            // 6枚のウィンドウを表示したらゲーム画面へ移行
            window.removeFromParent()
            audio.stop()
            let tr = SKTransition.fadeWithDuration(1.0)
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = .AspectFill
            self.scene!.view!.presentScene(newScene, transition: tr)

        }
        


    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let click = SKAction.playSoundFileNamed("click", waitForCompletion: true)

        for touch in touches {
            let location = touch.locationInNode(self)

            if self.nodeAtPoint(location).name == "next" {
                next.runAction(click)
                c += 1
            }
        }


    }

    func setEpilogue(name: String) {
        window = SKSpriteNode(imageNamed: name)
        window.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        window.zPosition = 10
        self.addChild(window)
    }

}