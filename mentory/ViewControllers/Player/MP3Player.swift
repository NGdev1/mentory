//
//  MP3Player.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import AVFoundation
import MediaPlayer

final class MP3Player: NSObject {
    // MARK: - Properties

    var player: AVPlayer?

    // MARK: - Init

    init(url: URL) {
        self.player = AVPlayer(url: url)
        super.init()
        setupAVAudioSession()
    }

    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("AVAudioSession is Active and Category Playback is set")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
        } catch {
            debugPrint("Error: \(error)")
        }
    }

    private func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Mentory"]

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            return .success
        }
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

    func pause() {
        if isPlaying() == true {
            player?.pause()
        }
    }

    func isLoading() -> Bool {
        return (player?.currentItem?.isPlaybackLikelyToKeepUp == false)
    }

    func setProgress(_ progress: Float) {
        guard let cmDuration: CMTime = player?.currentItem?.asset.duration
        else { return }
        let duration = CMTimeGetSeconds(cmDuration)
        let newTime: CMTime = CMTimeMake(value: Int64(duration * Double(progress)), timescale: 1)
        player?.seek(to: newTime)
    }

    func getProgress() -> Float {
        guard let cmDuration: CMTime = player?.currentItem?.asset.duration,
            let cmCurrentTime: CMTime = player?.currentTime()
        else { return 0 }
        let time = CMTimeGetSeconds(cmCurrentTime)
        let duration = CMTimeGetSeconds(cmDuration)
        return Float(time / duration)
    }
}
