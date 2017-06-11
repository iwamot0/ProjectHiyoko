//
//  ProgressBar.swift
//  HiyokoProject
//
//  Created by RockBooker on 7/25/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import SpriteKit



/// プログレスバーを生成するクラス
class ProgressBar: SKCropNode {


    override init() {
        super.init()

        let sprite = SKSpriteNode(imageNamed: "progressLine")
        sprite.anchorPoint = CGPoint(x: 0, y: 1.0)
        sprite.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: sprite.size.height)
        let maskSprite = SKSpriteNode(color: SKColor.blackColor(), size: sprite.size)
        maskSprite.anchorPoint = CGPoint(x: 0, y: 1.0)
        self.maskNode = maskSprite


        addChild(sprite)
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    /// 初期値設定メソッド (0.0 〜 1.0)
    func setProgress(progress: CGFloat) {
        self.maskNode?.xScale = progress
    }


    /// プログレスバーの数値を増やすメソッド
    func updateProgress(progress: CGFloat){
        self.maskNode?.xScale += progress
    }
}