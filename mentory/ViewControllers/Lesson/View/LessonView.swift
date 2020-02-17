//
//  LessonView.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Kingfisher
import MDFoundation
import UIKit

final class LessonView: UIView {
    struct Appearance {
        // static let headerHeight: CGFloat = 375
        // static let navBarStartTurningPoint: CGFloat = 220
        // static let navBarTurnСompletelyTurnPoint: CGFloat = 240
        static var headerHeight: CGFloat = 200
        static let navBarStartTurningPoint: CGFloat = 70
        static let navBarTurnСompletelyTurnPoint: CGFloat = 120
    }

    // MARK: - Properties

    @IBOutlet var headerView: MDHeaderView!
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nextLessonCellView: UIView!
    @IBOutlet var nextLessonContainerView: UIView!
    var nextLessonCell: LessonCell?

    @IBOutlet var nextLessonLabel: UILabel!

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
        initScrollViewContentInsets()
    }

    private func setupStyle() {
        Appearance.headerHeight += safeAreaInsets.top
        frame = UIScreen.main.bounds
        nextLessonCell = XibInitializer.loadFromXib(type: LessonCell.self)
        if let view = nextLessonCell?.contentView {
            nextLessonCellView.addSubview(view)
        }
        nextLessonLabel.text = Text.Lesson.nextLesson
        playButton.setTitle(Text.Lesson.listen, for: .normal)
        headerHeight.constant = Appearance.headerHeight
        headerView.addShadow(ofColor: .black)
        nextLessonCell?.contentView.makeEdgesEqualToSuperview()
    }

    private func initScrollViewContentInsets() {
        scrollView.contentInset = UIEdgeInsets(top: Appearance.headerHeight, left: 0, bottom: 70, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -Appearance.headerHeight)
    }

    // MARK: - Internal methods

    func displayLesson(_ viewModel: LessonViewModel) {
        headerView.updateContent(with: viewModel.lesson.backgroundImageUrl)
        titleLabel.text = viewModel.lesson.title
        headerView.setTitle(viewModel.lesson.title)
        if viewModel.lesson.tracks.count == 1 {
            subtitleLabel.text = Text.Lesson.subtitleOneTrack(viewModel.lesson.subtitle)
        } else if viewModel.lesson.tracks.count < 5 {
            subtitleLabel.text = Text.Lesson.subtitle2to4Tracks(viewModel.lesson.subtitle, viewModel.lesson.tracks.count)
        } else {
            subtitleLabel.text = Text.Lesson.subtitleFrom5Tracks(viewModel.lesson.subtitle, viewModel.lesson.tracks.count)
        }
        descriptionLabel.text = viewModel.lesson.description
        guard
            let nextLesson = viewModel.nextLesson,
            let nextLessonIsLocked = viewModel.nextLessonLocked
        else { return }
        nextLessonCell?.configure(with: nextLesson, isLocked: nextLessonIsLocked)
    }

    public func updateHeaderWithScroll(offset: CGPoint, navBarHeight: CGFloat) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        headerView.updateAlphaChangingByScroll(
            currentPoint: offset.y + scrollView.contentInset.top,
            startTurningWhitePoint: Appearance.navBarStartTurningPoint,
            turnСompletelyWhitePoint: Appearance.navBarTurnСompletelyTurnPoint
        )
        let minHeaderHeight: CGFloat = statusBarHeight + navBarHeight
        let height = max(offset.y > 0 ? 0 : -offset.y, minHeaderHeight)
        headerHeight.constant = height
    }
}

// MARK: - ViewImageBasedAnimatable

extension LessonView: ViewImageBasedAnimatable {
    var mainView: UIView {
        return self
    }

    var imageView: UIImageView {
        return headerView.imageView
    }

    var isImageDisappeared: Bool {
        let realOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        return realOffset > Appearance.navBarStartTurningPoint
    }
}
