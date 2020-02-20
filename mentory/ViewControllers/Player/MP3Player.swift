//
//  MP3Player.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import SwiftAudio

protocol MP3PlayerDelegate: AnyObject {
    func progressUpdated(_ value: Float)
}

final class MP3Player: NSObject {
    // MARK: - Properties

    var player: QueuedAudioPlayer
    let controller = RemoteCommandController()
    weak var delegate: MP3PlayerDelegate?

    // MARK: - Init

    init(tracks: [Track], current: Int) {
        self.player = QueuedAudioPlayer(remoteCommandController: controller)
        super.init()
        setupAVAudioSession()
        var items: [DefaultAudioItem] = []
        for track in tracks {
            let audioItem = DefaultAudioItem(audioUrl: track.url, sourceType: .stream)
            items.append(audioItem)
        }
        player.automaticallyWaitsToMinimizeStalling = true
        try? player.add(items: items)
        try? player.jumpToItem(atIndex: current)
        player.remoteCommands = [
            .play,
            .pause,
            .skipForward(preferredIntervals: [3]),
            .skipBackward(preferredIntervals: [3]),
        ]
        player.bufferDuration = 1
        player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
    }

    private func setupAVAudioSession() {
        do {
            try AudioSessionController.shared.set(category: .playback)
            try AudioSessionController.shared.activateSession()
        } catch {
            debugPrint("Error: \(error)")
        }
    }

    // MARK: - Internal methods

    func isPlaying() -> Bool {
        return player.playerState == .playing
    }

    func nextTrack() {
        try? player.next()
    }

    func previousTrack() {
        try? player.previous()
    }

    func play() {
        if isPlaying() == false {
            player.play()
        }
    }

    func stop() {
        player.stop()
    }

    func pause() {
        if isPlaying() == true {
            player.pause()
        }
    }

    func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.progressUpdated(self.getProgress())
        }
    }

    func setProgress(_ progress: Float) {
        player.seek(to: player.duration * Double(progress))
    }

    func getProgress() -> Float {
        return Float(player.currentTime / player.duration)
    }
}
