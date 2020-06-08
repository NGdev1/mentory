//
//  PlayerView.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Kingfisher
import MDFoundation
import UIKit

final class PlayerView: UIView {
    // MARK: - Properties

    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var trackSubtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var progressSlider: UISlider!

    @IBOutlet var backwardButton: UIButton!
    @IBOutlet var playSmallButton: UIButton!
    @IBOutlet var forwardButton: UIButton!

    var userChangingProgress: Bool = false

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Assets.backButton.image, for: .normal)
        button.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
        button.cornerRadius = 14
        return button
    }()

    lazy var barButtonItem = UIBarButtonItem(customView: backButton)

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        setupStyle()
    }

    private func setupStyle() {
        backgroundImageView.kf.indicatorType = .activity
    }

    // MARK: - Internal methods

    func showMusicIsLoading() {
        playButton.startShowingActivityIndicator()
    }

    func musicLoadingFinished() {
        playButton.stopShowingActivityIndicator()
    }

    func showProgress(_ pregress: Float) {
        progressSlider.value = pregress
    }

    func displayTrack(lesson: Lesson, track: Track) {
        if let imageUrl = URL(string: lesson.backgroundImageUrl) {
            backgroundImageView.kf.setImage(with: imageUrl)
        }
        titleLabel.text = lesson.title
        subtitleLabel.text = lesson.subtitle
        trackNameLabel.text = track.title
        trackSubtitleLabel.text = track.subtitle
    }

    func updateAppearance(backwardActive: Bool, isPlaying: Bool, forwardActive: Bool) {
        if backwardActive {
            backwardButton.setBackgroundImage(Assets.iconBackward.image, for: .normal)
        } else {
            backwardButton.setBackgroundImage(Assets.iconBackwardUnactive.image, for: .normal)
        }

        if forwardActive {
            forwardButton.setBackgroundImage(Assets.iconForward.image, for: .normal)
        } else {
            forwardButton.setBackgroundImage(Assets.iconForwardUnactive.image, for: .normal)
        }

        if isPlaying {
            playButton.setBackgroundImage(Assets.pauseBig.image, for: .normal)
            playSmallButton.setBackgroundImage(Assets.iconPause.image, for: .normal)
        } else {
            playButton.setBackgroundImage(Assets.playBig.image, for: .normal)
            playSmallButton.setBackgroundImage(Assets.iconPlay.image, for: .normal)
        }
    }
}
