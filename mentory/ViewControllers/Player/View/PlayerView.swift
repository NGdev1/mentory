//
//  PlayerView.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

final class PlayerView: UIView {
    // MARK: - Properties

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var progressSlider: UISlider!

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Assets.backButton.image, for: .normal)
        button.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        button.cornerRadius = 16
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

    private func setupStyle() {}

    // MARK: - Internal methods

    func showProgress(_ pregress: Float) {
        progressSlider.value = pregress
    }

    func displayLesson(_ lesson: Lesson) {
        backgroundImageView.image = lesson.backgroundImage
        titleLabel.text = lesson.title
        subtitleLabel.text = lesson.subtitle
    }
}
