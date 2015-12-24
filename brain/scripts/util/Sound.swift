//
//  Sound.swift
//  brain
//
//  Created by Yoshikazu Oda on 2015/01/24.
//  Copyright (c) 2015年 yoshinbo. All rights reserved.
//

import Foundation
import AudioToolbox

final class Sound {

    var audioPlayerHash: Dictionary<String, SystemSoundID> = [String: SystemSoundID]()

    class var sharedInstance : Sound {
        struct Static {
            static let instance : Sound = Sound()
        }
        return Static.instance
    }

    private init() {
        for soundName in soundList {
            var soundID: SystemSoundID = 0
            let path = NSBundle.mainBundle().URLForResource(soundName, withExtension: "mp3")
            AudioServicesCreateSystemSoundID(path!, &soundID)
            audioPlayerHash[soundName] = soundID
        }
    }

    func playBySoundName(soundName: String) {
        if let soundID = audioPlayerHash[soundName] {
            AudioServicesPlaySystemSound(soundID)
        }
    }
}

// NOTE: AVFoundationは再生が終わらないと次を再生できないのでAudioToolboxを使うことにした。
//import AVFoundation
//
//final class Sound {
//
//    var audioPlayerHash: Dictionary<String, AVAudioPlayer> = [String: AVAudioPlayer]()
//
//    class var sharedInstance : Sound {
//        struct Static {
//            static let instance : Sound = Sound()
//        }
//        return Static.instance
//    }
//
//    private init() {
//        for soundName in soundList {
//            var path = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
//            var audioPlayer = AVAudioPlayer(contentsOfURL: path, error: nil)
//            audioPlayer.prepareToPlay()
//            audioPlayerHash[soundName] = audioPlayer
//        }
//    }
//
//    func playBySoundName(soundName: String) {
//        if let audioPlayer = audioPlayerHash[soundName] {
//            if audioPlayer.playing != true {
//                audioPlayer.play()
//            }
//        }
//    }
//}
