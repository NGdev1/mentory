//
//  MP3Player.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import AVFoundation

final class MP3Player: NSObject {
    // MARK: - Properties

    var player: AVPlayer?

    // MARK: - Init

    init(url: URL) {
        self.player = AVPlayer(url: url)
        super.init()
    }

    // MARK: - Internal methods

    func isPlaying() -> Bool {
        return (player?.rate != 0)
    }

    func play() {
        if isPlaying() == false {
            player?.play()
        }
    }

    func stop() {
        if isPlaying() == true {
            // player?.stop()
            // player?.currentTime = 0
        }
    }

    func pause() {
        if isPlaying() == true {
            player?.pause()
        }
    }

    func getProgress() -> Float {
        guard let cmDuration: CMTime = player?.currentItem?.asset.duration,
            let cmCurrentTime: CMTime = player?.currentTime()
        else { return 0 }
        let theCurrentTime = CMTimeGetSeconds(cmCurrentTime)
        let theCurrentDuration = CMTimeGetSeconds(cmDuration)
        return Float(theCurrentTime / theCurrentDuration)
    }
}
