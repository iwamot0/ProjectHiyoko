//
//  EvolutionScene.swift
//  ProjectHiyoko
//
//  Created by RockBooker on 7/28/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit
import AVFoundation


class EvolutionScene: SKScene {
    
    var audio = BGM(bgm: 3)

    var bg: SKSpriteNode!
    var player: SKSpriteNode!
    var beforeEvol: SKSpriteNode!
    var afterEvol: SKSpriteNode!
    var end = false

    let savePoint = UserData.defaults.integerForKey("SAVEPOINT")

    override func didMoveToView(view: SKView) {
        audio.volume = 0.5
        audio.numberOfLoops = -1
        audio.play()


        beforeEvol = SKSpriteNode(imageNamed: "beforeEvol")
        beforeEvol.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        beforeEvol.zPosition = 2

        self.addChild(beforeEvol)

        setBackground()

        setCurrentPlayer()

        evolutionAction()

        NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: #selector(EvolutionScene.setEnd), userInfo: nil, repeats: false)


    }

    func setBackground() {
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .Nearest

        self.bg = SKSpriteNode(texture: texture)
        bg.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bg.zPosition = -10
        bg.size = self.size
        bg.alpha = 0.5


        self.addChild(bg)
    }

    func setCurrentPlayer() {
        let hiyokoObject = MakingHiyoko()
        self.player = hiyokoObject.player
        player.size = CGSize(width: player.size.width*3.0, height: player.size.height*3.0)
        player.position = CGPoint(x: UIScreen.mainScreen().bounds.width*0.2, y: UIScreen.mainScreen().bounds.height*0.2)
        player.physicsBody?.dynamic = false


        self.addChild(player)
    }

    func evolutionAction() {

        let currentName = "hiyoko\(savePoint)"
        let currentPlayerTexture = SKTexture(imageNamed: currentName)

        let nextName = "hiyoko\(savePoint + 1)"
        let nextPlayerTexture = SKTexture(imageNamed: nextName)


        let waitAction = SKAction.waitForDuration(2.0)
        let moveCenter = SKAction.moveTo(CGPoint(x: self.frame.size.width*0.5, y: self.frame.size.height*0.1), duration: 2.0)


        let scaleOut1 = SKAction.scaleTo(0.1, duration: 1.0)
        let scaleIn1 = SKAction.scaleTo(1.0, duration: 1.0)
        let scaleOut2 = SKAction.scaleTo(0.1, duration: 0.8)
        let scaleIn2 = SKAction.scaleTo(1.0, duration: 0.8)
        let scaleOut3 = SKAction.scaleTo(0.1, duration: 0.6)
        let scaleIn3 = SKAction.scaleTo(1.0, duration: 0.6)
        let scaleOut4 = SKAction.scaleTo(0.1, duration: 0.4)
        let scaleIn4 = SKAction.scaleTo(1.0, duration: 0.4)
        let scaleOut5 = SKAction.scaleTo(0.1, duration: 0.2)
        let scaleIn5 = SKAction.scaleTo(1.0, duration: 0.2)

        // ポケモン風の進化のアクション
        let arr1 = [scaleOut1, scaleIn1, scaleOut2, scaleIn2, scaleOut3, scaleIn3, scaleOut4, scaleIn4, scaleOut5, scaleIn5 ]
        let arr2 = [scaleOut5, scaleIn5]


        let one = SKAction.sequence(arr1)
        let two = SKAction.repeatAction(SKAction.sequence(arr2), count: 5)
        let frame = SKAction.animateWithTextures([currentPlayerTexture, nextPlayerTexture], timePerFrame: 0.1)
        let three = SKAction.repeatAction(SKAction.group([SKAction.sequence([scaleOut4, scaleIn4]), frame]), count: 1)


        let action = SKAction.sequence([waitAction, moveCenter, one, two, three])

        player.runAction(action)

    }

    override func update(currentTime: NSTimeInterval) {


        if end == true {
            // 進化が終了した
            after()
        }

    }

    func setEnd() {

        audio.stop()
        let kirakira = SKAction.playSoundFileNamed("kirakira", waitForCompletion: true)
        self.player.runAction(kirakira)

        end = true
    }

    func after() {
        beforeEvol.removeFromParent()
        afterEvol = SKSpriteNode(imageNamed: "afterEvol")
        afterEvol.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        afterEvol.zPosition = 3
        self.addChild(afterEvol)

        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let click = SKAction.playSoundFileNamed("click", waitForCompletion: true)

        for _ in touches {
            if end == true {
                audio.stop()
                player.runAction(click)

                UserData.defaults.setObject(savePoint + 1, forKey: "SAVEPOINT")
                UserData.defaults.setObject(0.0, forKey: "SAVEPROGRESS")



                let tr = SKTransition.fadeWithDuration(1.0)
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = .AspectFill
                self.scene!.view!.presentScene(newScene, transition: tr)

                
            }
        }
    }
}
