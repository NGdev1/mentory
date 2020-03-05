//
//  PlayerController.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import AVFoundation
import MDFoundation
import UIKit

public class PlayerController: UIViewController {
    // MARK: - Properties

    lazy var player: MP3Player = MP3Player(tracks: lesson.tracks, current: currentIndex)

    lazy var customView: PlayerView? = view as? PlayerView
    var lesson: Lesson
    var currentIndex: Int

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
        player.delegate = customView
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
        currentIndex -= 1
        player.previousTrack()
        updatePlayerAppearance(isPlaying: true)
    }

    @objc func nextTrackTapped(_ sender: UIButton) {
        guard currentIndex != lesson.tracks.count - 1 else { return }
        currentIndex += 1
        player.nextTrack()
        updatePlayerAppearance(isPlaying: true)
    }

    @objc func playButtonTapped(_ sender: UIButton) {
        if player.isPlaying() == false {
            player.play()
            updatePlayerAppearance(isPlaying: true)
        } else {
            player.pause()
            updatePlayerAppearance(isPlaying: false)
        }
    }

    private func updatePlayerAppearance(isPlaying: Bool) {
        customView?.displayTrack(lesson: lesson, track: lesson.tracks[currentIndex])
        customView?.updateAppearance(
            backwardActive: currentIndex != 0,
            isPlaying: isPlaying,
            forwardActive: currentIndex != lesson.tracks.count - 1
        )
    }

    @objc func dismissController() {
        player.stop()
        navigationController?.popViewController()
    }
}
