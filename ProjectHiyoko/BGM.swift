//
//  BGM.swift
//  ProjectHiyoko
//
//  Created by RockBooker on 7/30/16.
//  Copyright © 2016 rockbooker. All rights reserved.
//

import Foundation
import AVFoundation

class BGM:AVAudioPlayer{
    let bgmList = [
        0: "title",
        1: "field",
        2: "epilogue",
        3: "evolution"
    ]
    init (bgm:Int){
        let bgmUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(bgmList[bgm], ofType:"mp3")!)
        try! super.init(contentsOfURL: bgmUrl, fileTypeHint: "mp3")
    }
}
