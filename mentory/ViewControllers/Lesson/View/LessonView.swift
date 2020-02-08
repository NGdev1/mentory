//
//  LessonView.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

final class LessonView: UIView {
    struct Appearance {
        static let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 370)
        static let navBarStartTurningPoint: CGFloat = 220
        static let navBarTurnСompletelyTurnPoint: CGFloat = 240
    }

    // MARK: - Properties

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nextLessonCellView: UIView!
    @IBOutlet var nextLessonContainerView: UIView!
    var nextLessonCell: LessonCell?

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

    private func setupStyle() {
        frame = UIScreen.main.bounds
        nextLessonCell = XibInitializer.loadFromXib(type: LessonCell.self)
        if let view = nextLessonCell?.contentView {
            nextLessonCellView.addSubview(view)
        }
        nextLessonCell?.contentView.makeEdgesEqualToSuperview()
    }

    // MARK: - Internal methods

    func displayLesson(_ viewModel: LessonViewModel) {
        headerImageView.image = viewModel.lesson.backgroundImage
        titleLabel.text = viewModel.lesson.title
        subtitleLabel.text = viewModel.lesson.subtitle
        descriptionLabel.text = "Can't end BackgroundTask: no background task exists with identifier 12, or it may have already been ended. Break in UIApplicationEndBackgroundTaskError() to debug."
        descriptionLabel.text = (descriptionLabel.text ?? "") + (descriptionLabel.text ?? "")
        descriptionLabel.text = (descriptionLabel.text ?? "") + (descriptionLabel.text ?? "")
        guard
            let nextLesson = viewModel.nextLesson,
            let nextLessonIsLocked = viewModel.nextLessonLocked
        else { return }
        nextLessonCell?.configure(with: nextLesson, isLocked: nextLessonIsLocked)
    }
}

// MARK: - ViewImageBasedAnimatable

extension LessonView: ViewImageBasedAnimatable {
    var mainView: UIView {
        return self
    }

    var imageView: UIImageView {
        return headerImageView
    }

    var isImageDisappeared: Bool {
        let realOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        return realOffset > Appearance.navBarStartTurningPoint
    }
}
