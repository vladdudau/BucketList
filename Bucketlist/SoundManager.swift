//
//  SoundManager.swift
//  Bucketlist
//
//  Created by user215924 on 4/30/22.
//

import Foundation
import AVFoundation
import AVFAudio

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}
