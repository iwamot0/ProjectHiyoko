//
//  MakingHiyoko.swift
//  HiyokoProject
//
//  Created by RockBooker on 7/24/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit

/// Singletonクラスとして使用すること
class MakingHiyoko {

    // MARK: - Define property
    var player: SKSpriteNode!

    private var hiyokoName: String!

    // 各ひよこたびにハートを壊した時のゲージの上がり幅は違う
    var value: Double
    //  Value of Tests
    private var values = [0.0075/1.0, 0.0075/2.0, 0.0075/4.0, 0.0075/6.0, 0.0075/8.0, 0.0075/10.0, 0.0075/12.0, 0.0075/14.0]

    let savePoint = UserData.defaults.integerForKey("SAVEPOINT")


    // MARK: - Define Method

    /// UserDefaultsで保存されたデータを基にひよこを生成する
    init() {
        hiyokoName = "hiyoko\(savePoint)"
        let texture = SKTexture(imageNamed: hiyokoName)
        texture.filteringMode = .Nearest
        player = SKSpriteNode(texture: texture)
        player.anchorPoint = CGPoint(x: 0.5, y: 0)

        player.position = CGPoint(x: UIScreen.mainScreen().bounds.width*0.2, y: UIScreen.mainScreen().bounds.height*0.2)
        player.zPosition = 50
        player.size = CGSize(width: player.size.width*0.5, height: player.size.height*0.5)

        player.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.contactTestBitMask = 1
        player.physicsBody?.restitution = 0.5
        player.physicsBody?.friction = 0.5


        self.value = values[savePoint]
    }
}
