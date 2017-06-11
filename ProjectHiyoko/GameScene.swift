//
//  GameScene.swift
//  Hiyoko
//
//  Created by RockBooker on 7/19/16.
//  Copyright (c) 2016 RockBooker. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {


    // MARK: - Define Property
    var audio = BGM(bgm: 1)

    var bg: SKSpriteNode!
    var player: SKSpriteNode!
    var hiyokoObject: MakingHiyoko!
    // 名前表示 進化するごとに上部バー左にLevel[Integer]と表示する
    var levelLabel: SKLabelNode!
    var topBar: SKSpriteNode!
    var progressBar: ProgressBar!

    // ラベルが出ている状態か
    var window: SKSpriteNode!

    // [ index : (Heart, HeartPosition, true/false) ]
    // 末尾のBool値でフィールドに出現しているか否かを判断する
    var hearts = [Int : (SKSpriteNode, CGPoint, Bool)]()


    var firstTimer: NSTimer?
    var heartTimer: NSTimer?

    var interstitialCount = 0       // ハートを壊した時にカウント。
    var leastShow = false           // 一度表示しているか否か
    var interstitialCountLabel: SKLabelNode!

    var savePoint: Int!
    var saveProgress: Float!



    // MARK:  - Default System Function

    override func didMoveToView(view: SKView) {

        savePoint = UserData.defaults.integerForKey("SAVEPOINT")
        saveProgress = UserData.defaults.floatForKey("SAVEPROGRESS")


        audio.volume = 0.5
        audio.numberOfLoops = -1
        audio.play()

        // 登場したキャラクタは右隅に配置
        if savePoint > 0 {
            setBeforeEvolutionCharacters()
        }

        setBackground()
        // standardUserDefaultsの値を元にひよこを生成
        setHiyoko(savePoint)
        // 上部のステータスバーを描写
        setStetusBar()
        // 上部にひよこの成長ゲージを表示
        setProgressBar()
        // ハート配置
        setFirstHeart()
        // あとハートを何個壊したらインタースティシャル広告が表示されるかを表示
        showInterstitialCount()

        




        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: self.size.height*0.05, width: self.size.width, height: self.size.height))
        self.physicsBody?.resting = true


        self.heartTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.appearHeart), userInfo: nil, repeats: true)


    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let particle = SKEmitterNode(fileNamed: "star.sks")
        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.waitForDuration(2.0)
        let sequenceAction = SKAction.sequence([durationAction, removeAction])

        for touch in touches {
            let touchedLocation = touch.locationInNode(self)
            let currentLocation = self.player.position

            self.player.physicsBody?.velocity = CGVector.zero

            // 今プレイヤーがいるところより右にタップすればひよこは右方向にジャンプし、
            // そうでなければ左方向にジャンプする
            if currentLocation.x < touchedLocation.x {
                particle?.position = player.position
                self.addChild(particle!)
                particle?.runAction(sequenceAction)
                particle?.alpha = 1
                let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.5)
                particle?.runAction(fadeAction)

                self.player.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 20))
            } else {
                particle?.position = player.position
                self.addChild(particle!)
                particle?.runAction(sequenceAction)
                particle?.alpha = 1
                let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.5)
                particle?.runAction(fadeAction)

                self.player.physicsBody?.applyImpulse(CGVector(dx: -5, dy: 20))
            }


        }
    }


    override func update(currentTime: CFTimeInterval) {
        // ゲージが満タンになった時に進化させる
        // progressBar.maskNode?.xScale : プログレスバーの合計値
        if progressBar.maskNode?.xScale > 1.0 && savePoint != 7 {

            audio.stop()
            
            let scene = EvolutionScene(size: self.size)
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithDuration(2.0)
            self.view?.presentScene(scene, transition: transition)


        }

        // 40個壊した時点で邪魔にならないように一度だけインタースティシャル広告を表示
        if interstitialCount == 40 && leastShow == false {
            showInterstitial()
            leastShow = true
            self.interstitialCount = 0
            self.interstitialCountLabel.text = "0個"

        }

        if progressBar.maskNode?.xScale > 1.0 && savePoint == 7 {

            audio.stop()

            let scene = EndingScene(size: self.size)
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithDuration(2.0)
            self.view?.presentScene(scene, transition: transition)



        }

        self.interstitialCountLabel.text = "\(String(40 - self.interstitialCount))個"

    }

    // あと何個でインタースティシャル広告が表示されるか？
    func showInterstitialCount() {
        let word = SKLabelNode(fontNamed: "Menlo")
        word.fontSize = 15
        word.fontColor = SKColor.blackColor()
        word.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.95)
        word.text = "広告表示まであと"
        word.zPosition = 30
        self.addChild(word)

        self.interstitialCountLabel = SKLabelNode(fontNamed: "Menlo")
        interstitialCountLabel.fontSize = 20
        interstitialCountLabel.fontColor = SKColor.blackColor()
        interstitialCountLabel.position = CGPoint(x: self.size.width*0.8, y: self.size.height*0.9)
        interstitialCountLabel.text = "0個"
        interstitialCountLabel.zPosition = 30
        self.addChild(interstitialCountLabel)
    }



    // プレイヤーが衝突した場合はハートは消し、
    // フラグ(exist)をfalseに設定して消す
    func didBeginContact(contact: SKPhysicsContact) {

        let parin = SKAction.playSoundFileNamed("parin", waitForCompletion: true)
        let particle = SKEmitterNode(fileNamed: "heart.sks")

        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.waitForDuration(2.0)
        let sequenceAction = SKAction.sequence([durationAction, removeAction])


        for (index, (heart, _, exist)) in hearts {
            if (contact.bodyA.node!.name == heart.name) ||
                (contact.bodyB.node!.name == heart.name) {
                // フィールド上に存在しているならば
                if exist == true {
                    interstitialCount += 1

                    if leastShow == true {
                        leastShow = false
                    }
                    

                    player.runAction(parin)
                    particle?.position = player.position
                    self.addChild(particle!)
                    particle?.runAction(sequenceAction)
                    particle?.alpha = 1
                    let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.5)
                    particle?.runAction(fadeAction)


                    self.progressBar.updateProgress(CGFloat(hiyokoObject.value))
                    UserData.defaults.setObject(self.progressBar.maskNode?.xScale, forKey: "SAVEPROGRESS")
                    UserData.defaults.synchronize()

                    hearts[index]!.2 = false
                    hearts[index]!.0.removeFromParent()
                }
            }
        }
    }



    // MARK: - Define My Functions

    func settingWindow(name: String) {
        window = SKSpriteNode(imageNamed: name)
        window.anchorPoint = CGPoint(x: 0.5, y: 1)
        window.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        self.addChild(window)


    }


    func setBackground() {
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .Nearest

        bg = SKSpriteNode(texture: texture)
        bg.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        bg.zPosition = -10
        bg.size = self.size


        self.addChild(bg)
    }


    func setHiyoko(savePoint: Int) {

        // 初回での読み出しは0となっている
        hiyokoObject = MakingHiyoko()

        player = hiyokoObject.player

        self.addChild(player)
    }


    func setStetusBar() {
        levelLabel = SKLabelNode(fontNamed: "Menlo")
        levelLabel.fontSize = 28
        levelLabel.fontColor = UIColor.darkTextColor()
        levelLabel.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.94)
        levelLabel.zPosition = 10
        levelLabel.text = "レベル\(savePoint)"

        topBar = SKSpriteNode(imageNamed: "topBar")
        topBar.anchorPoint = CGPoint(x: 0, y: 1)
        topBar.position = CGPoint(x: 0, y: self.size.height)
        topBar.zPosition = 5


        self.addChild(levelLabel)
        self.addChild(topBar)
    }


    func setProgressBar() {
        progressBar = ProgressBar()
        progressBar.setProgress(CGFloat(saveProgress))
        // StetusBarの下に配置する
        progressBar.position = CGPoint(x: 3, y: self.size.height - topBar.size.height + 8)
        progressBar.zPosition = 10

        let texture = SKTexture(imageNamed: "progressBackground")
        let progressBackground = SKSpriteNode(texture: texture)
        progressBackground.size = CGSize(width: self.size.width, height: progressBackground.size.height)
        progressBackground.position = CGPoint(x: self.size.width*0.5, y: self.size.height - topBar.size.height + 5)
        progressBackground.zPosition = 9


        self.addChild(progressBar)
        self.addChild(progressBackground)
    }


    /// ハートの初期化処理
    func setFirstHeart() {


        // フィールドに出現するハートの位置を指定
        func makingHeartPosition() -> [CGPoint] {
            // 画面を元に座標を求めるための倍率を格納
            let XPos = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
            let YPos = [0.35, 0.45, 0.55, 0.65, 0.75, 0.85]

            var heartPositions: [CGPoint] = []
            for y in YPos {
                for x in XPos {
                    let p = CGPoint(x: self.size.width * CGFloat(x), y: self.size.height * CGFloat(y))
                    heartPositions.append(p)
                }
            }

            return heartPositions
        }

        let heartPositions = makingHeartPosition()
        let texture = SKTexture(imageNamed: "heart")

        for i in 0..<heartPositions.count {
            let heart = makeHeart(texture)
            heart.position = heartPositions[i]
            heart.name = "heart\(i)"
            hearts[i] = (heart, heart.position, true)
            self.addChild(heart)
        }
    }


    /// 一つのハートを生成する処理
    func makeHeart(texture: SKTexture) -> SKSpriteNode {
        let heart = SKSpriteNode(texture: texture)
        heart.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        heart.physicsBody?.dynamic = false
        heart.physicsBody?.resting = true
        heart.physicsBody?.allowsRotation = true
        heart.physicsBody?.contactTestBitMask = 1
        heart.physicsBody?.restitution = 0.1
        heart.physicsBody?.friction = 0.1

        let scaleUp = SKAction.scaleTo(1.5, duration: 1.0)
        let scaleDw = SKAction.scaleTo(1.0, duration: 1.0)
        let scaleUpDown = SKAction.sequence([scaleUp, scaleDw])
        heart.runAction(SKAction.repeatActionForever(scaleUpDown))


        return heart
    }

    /// ハートを出現させる処理
    func appearHeart() {
        let texture = SKTexture(imageNamed: "heart")

        for (index, (_, point, exist)) in hearts {
            if exist == false {
                hearts[index]!.0 = makeHeart(texture)
                hearts[index]!.0.position = point
                hearts[index]!.0.name = "heart\(index)"
                // 再度登録
                hearts[index]!.2 = true
                self.addChild(hearts[index]!.0)
                // 一つ生成したら処理を終了する
                return


            }
        }
    }

    func showInterstitial() {

        let showResult = NADInterstitial.sharedInstance().showAdFromViewController(UIApplication.sharedApplication().keyWindow?.rootViewController)

        switch(showResult){
        case .AD_SHOW_SUCCESS:
            print("広告の表示に成功しました。")
            break
        case .AD_SHOW_ALREADY:
            print("既に広告が表示されています。")
            break
        case .AD_FREQUENCY_NOT_REACHABLE:
            print("広告のフリークエンシーカウントに達していません。")
            break
        case .AD_LOAD_INCOMPLETE:
            print("抽選リクエストが実行されていない、もしくは実行中です。")
            break
        case .AD_REQUEST_INCOMPLETE:
            print("抽選リクエストに失敗しています。")
            break
        case .AD_DOWNLOAD_INCOMPLETE:
            print("広告のダウンロードが完了していません。")
            break
        case .AD_CANNOT_DISPLAY:
            print("指定されたViewControllerに広告が表示できませんでした。")
            break

        }
    }

    func setBeforeEvolutionCharacters() {
        var x = 0.9
        let y = 0.15
        var z = 10

        
        var characters = [SKTexture]()
        for i in 0..<savePoint {
            let textureName = "hiyoko\(i)"
            let texture = SKTexture(imageNamed: textureName)
            characters.append(texture)

        }

        for chara in characters {
            let sprite = SKSpriteNode(texture: chara)
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.position = CGPoint(x: self.size.width*CGFloat(x), y: self.size.height*CGFloat(y))
            sprite.size = CGSize(width: sprite.size.width*0.5, height: sprite.size.height*0.5)
            x -= 0.1
            sprite.zPosition = CGFloat(z)
            z += 1
            sprite.physicsBody = SKPhysicsBody(texture: chara, size: sprite.size)
            sprite.physicsBody?.dynamic = false
            sprite.physicsBody?.allowsRotation = false
            sprite.physicsBody?.collisionBitMask = 1
            sprite.physicsBody?.friction = 1.0
            sprite.physicsBody?.restitution = 1.0
            self.addChild(sprite)

        }
    }

}
