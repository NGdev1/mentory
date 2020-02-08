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
        navigationItem.backBarButtonItem = customView?.barButtonItem
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
    }

    @objc func updateProgress() {
        let progress = player?.getProgress() ?? 0.0
        customView?.showProgress(progress)
    }

    @objc func playButtonTapped(_ sender: UIButton) {
        if player?.isPlaying() == false {
            player?.play()
        } else {
            player?.pause()
        }
    }

    @objc func dismissController() {
        navigationController?.popViewController()
    }
}
