//
//  PlayerController.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import Storable
import SwiftAudio
import UIKit

public class PlayerController: UIViewController {
    // MARK: - Properties

    lazy var player: MP3Player = .init(tracks: lesson.tracks, current: currentIndex)

    lazy var customView: PlayerView? = view as? PlayerView
    var lesson: Lesson
    var currentIndex: Int
    var progress: Float = 0

    // MARK: - Init

    public init(lesson: Lesson, startIndex: Int) {
        self.lesson = lesson
        self.currentIndex = startIndex
        super.init(
            nibName: Utils.getClassName(PlayerView.self),
            bundle: Bundle(for: PlayerView.self)
        )
        setupAppearance()
        addActionHandlers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        navigationItem.leftBarButtonItem = customView?.barButtonItem
        updatePlayerAppearance(isPlaying: true)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.playButton.addTarget(
            self,
            action: #selector(playButtonTapped(_:)),
            for: .touchUpInside
        )
        customView?.playSmallButton.addTarget(
            self,
            action: #selector(playButtonTapped(_:)),
            for: .touchUpInside
        )
        customView?.forwardButton.addTarget(
            self,
            action: #selector(nextTrackTapped(_:)),
            for: .touchUpInside
        )
        customView?.backwardButton.addTarget(
            self,
            action: #selector(previousTrackTapped(_:)),
            for: .touchUpInside
        )
        customView?.backButton.addTarget(
            self,
            action: #selector(dismissController),
            for: .touchUpInside
        )
        customView?.progressSlider.addTarget(
            self,
            action: #selector(sliderValueChanged(slider:event:)),
            for: .valueChanged
        )
        player.delegate = self
    }

    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else { return }
        if touchEvent.phase == .ended {
            player.setProgress(customView?.progressSlider.value ?? 0)
            customView?.userChangingProgress = false
        } else {
            customView?.userChangingProgress = true
        }
    }

    @objc func previousTrackTapped(_ sender: UIButton) {
        guard currentIndex != 0 else { return }
        guard lesson.tracks[currentIndex - 1].isLocked == false || AppService.shared.app.appState == .premium else {
            showPurchasePage()
            return
        }
        currentIndex -= 1
        player.previousTrack()
    }

    @objc func nextTrackTapped(_ sender: UIButton) {
        guard currentIndex != lesson.tracks.count - 1 else { return }
        guard lesson.tracks[currentIndex + 1].isLocked == false || AppService.shared.app.appState == .premium else {
            showPurchasePage()
            return
        }
        currentIndex += 1
        player.nextTrack()
    }

    @objc func playButtonTapped(_ sender: UIButton) {
        if player.isPlaying() == false {
            player.play()
        } else {
            player.pause()
        }
    }

    @objc func dismissController() {
        player.stop()
        navigationController?.popViewController()
    }

    // MARK: - Private methods

    func showPurchasePage() {
        let nextController = BuyController()
        nextController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(nextController, animated: true)
        }
    }

    private func updatePlayerAppearance(isPlaying: Bool) {
        customView?.displayTrack(lesson: lesson, track: lesson.tracks[player.currentIndex])
        customView?.updateAppearance(
            backwardActive: currentIndex != 0,
            isPlaying: isPlaying,
            forwardActive: currentIndex != lesson.tracks.count - 1
        )
    }
}

// MARK: - MP3PlayerDelegate

extension PlayerController: MP3PlayerDelegate {
    func stateChanged(_ state: AudioPlayerState) {
        switch state {
        case .loading:
            customView?.showMusicIsLoading()
        case .playing:
            updatePlayerAppearance(isPlaying: true)
        case .ready:
            customView?.musicLoadingFinished()
        default:
            if progress > 0.97 {
                player.setProgress(0)
            }
            updatePlayerAppearance(isPlaying: false)
        }
    }

    func progressUpdated(_ value: Float) {
        guard lesson.tracks[player.currentIndex].isLocked == false || AppService.shared.app.appState == .premium else {
            showPurchasePage()
            player.pause()
            return
        }

        if customView?.userChangingProgress == false {
            progress = value
            customView?.showProgress(value)
            if currentIndex != player.currentIndex {
                currentIndex = player.currentIndex
                updatePlayerAppearance(isPlaying: true)
            }
        }
    }
}
