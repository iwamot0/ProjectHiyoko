//
//  EpilogueScene.swift
//  ProjectHiyoko
//
//  Created by RockBooker on 7/30/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit
import AVFoundation


class EndingScene: SKScene {

    var i: Int = 1
    var c: Int = 0

    var window: SKSpriteNode!
    var next: SKSpriteNode!

    var audio = BGM(bgm: 2)

    override func didMoveToView(view: SKView) {
        audio.numberOfLoops = -1
        audio.play()
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bg.size = self.size
        bg.zPosition = -10
        self.addChild(bg)

        let hiyoko = SKSpriteNode(imageNamed: "hiyoko7")
        hiyoko.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        hiyoko.zPosition = 0
        hiyoko.size = CGSize(width: hiyoko.size.width*2.0, height: hiyoko.size.height*2.0)
        self.addChild(hiyoko)

        let texture = SKTexture(imageNamed: "heart")
        let h1 = SKSpriteNode(texture: texture)
        let h2 = SKSpriteNode(texture: texture)

        h1.position = CGPoint(x: self.size.width*0.2, y: self.size.height*0.5)
        h2.position = CGPoint(x: self.size.width*0.8, y: self.size.height*0.5)
        let t = CGSize(width: h1.size.width*2.0, height: h1.size.height*2.0)

        h1.size = t
        h2.size = t

        h1.zPosition = 0
        h2.zPosition = 0

        let scaleUp = SKAction.scaleTo(1.5, duration: 1.0)
        let scaleDw = SKAction.scaleTo(1.0, duration: 1.0)
        let scaleUpDown = SKAction.sequence([scaleUp, scaleDw])

        h1.runAction(SKAction.repeatActionForever(scaleUpDown))
        h2.runAction(SKAction.repeatActionForever(scaleUpDown))
        

        addChild(h1)
        addChild(h2)

        

        next = SKSpriteNode(imageNamed: "nextButton")
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        next.zPosition = 10
        next.size = CGSize(width: next.size.width*2.0, height: next.size.height*2.0)
        next.name = "next"
        self.addChild(next)

        setEnding("end\(i)")


    }


    override func update(currentTime: NSTimeInterval) {

        // そうでなければ、次へボタンが押されるたびにウィンドウを切り替えて物語を語る
        if i != 4 && i == c {
            window.removeFromParent()
            i += 1
            setEnding("end\(i)")

        }

        if c == 4 {
            // クリア画面処理
            window.removeFromParent()
            audio.stop()

            // ユーザーデータをすべて削除
            UserData.defaults.setObject(false, forKey: "NOTFIRST")
            UserData.defaults.setObject(0.0, forKey: "SAVEPROGRESS")
            UserData.defaults.setObject(0, forKey: "SAVEPOINT")


            let tr = SKTransition.fadeWithDuration(2.0)
            let newScene = StartMenu(size: self.size)
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

    func setEnding(name: String) {
        window = SKSpriteNode(imageNamed: name)
        window.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        window.zPosition = 10
        self.addChild(window)
    }
    
}