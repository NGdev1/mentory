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

    var player: MP3Player?
    var timer: Timer?

    lazy var customView: PlayerView? = view as? PlayerView
    var lesson: Lesson

    var userChangingProgress: Bool = false

    // MARK: - Init

    public init(lesson: Lesson) {
        self.lesson = lesson
        super.init(
            nibName: Utils.getClassName(PlayerView.self),
            bundle: Bundle(for: PlayerView.self)
        )
        setupAppearance()
        setupPlayer()
        setupTimer()
        addActionHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer() {
        guard let url = URL(
            string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
            // string: "https://www.myinstants.com/media/sounds/cade-o-respeito.mp3"
        ) else {
            return
        }
        player = MP3Player(url: url)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateProgress),
            userInfo: nil,
            repeats: true
        )
    }

    private func setupAppearance() {
        navigationItem.leftBarButtonItem = customView?.barButtonItem
        customView?.displayLesson(lesson)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.playButton.addTarget(
            self,
            action: #selector(playButtonTapped(_:)),
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
    }

    @objc func updateProgress() {
        guard userChangingProgress == false else {
            return
        }
        let progress = player?.getProgress() ?? 0.0
        if player?.isLoading() ?? true {
            customView?.showMusicIsLoading()
        } else {
            customView?.musicLoadingFinished()
        }
        customView?.showProgress(progress)
    }

    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else { return }
        if touchEvent.phase == .ended {
            userChangingProgress = false
            player?.setProgress(customView?.progressSlider.value ?? 0)
        } else {
            userChangingProgress = true
        }
    }

    @objc func playButtonTapped(_ sender: UIButton) {
        if player?.isPlaying() == false {
            player?.play()
            customView?.playButton.setBackgroundImage(Assets.pauseBig.image, for: .normal)
        } else {
            player?.pause()
            customView?.playButton.setBackgroundImage(Assets.playBig.image, for: .normal)
        }
    }

    @objc func dismissController() {
        navigationController?.popViewController()
    }
}
