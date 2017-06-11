//
//  GameViewController.swift
//  Hiyoko
//
//  Created by RockBooker on 7/19/16.
//  Copyright (c) 2016 RockBooker. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController, NADViewDelegate {

    private var nadView: NADView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // NADViewクラスを生成
        nadView = NADView(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 50, width: 320, height: 50), isAdjustAdSize: true)
        // 広告枠のapikey/spotidを設定(必須)
        // apiKey	6609d040b55c99d96d2aa7f8d4cafda16779acf1
        // spotID	632772

        nadView.setNendID("6609d040b55c99d96d2aa7f8d4cafda16779acf1",
                          spotID: "632772")
        // nendSDKログ出力の設定(任意)
        nadView.isOutputLog = false
        // delegateを受けるオブジェクトを指定(必須)
        nadView.delegate = self // 読み込み開始(必須)
        nadView.load()
        // 通知有無にかかわらずViewに乗せる場合
        self.view.addSubview(nadView)


        let scene = StartMenu()


        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true




        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size


        skView.presentScene(scene)

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
