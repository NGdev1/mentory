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

    var dataSource: LessonViewDataSource?

    @IBOutlet var headerView: MDHeaderView!
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var tableView: UITableView!

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
        initTableViewContentInsets()
    }

    private func setupStyle() {
        Appearance.headerHeight += safeAreaInsets.top
        frame = UIScreen.main.bounds
        playButton.setTitle(Text.Lesson.listen, for: .normal)
        playButton.addShadow(ofColor: .black, radius: 20, opacity: 0.5)
        headerHeight.constant = Appearance.headerHeight
        headerView.addShadow(ofColor: .black)
    }

    private func initTableViewContentInsets() {
        tableView.contentInset = UIEdgeInsets(
            top: Appearance.headerHeight, left: 0, bottom: 80, right: 0
        )
        tableView.contentOffset = CGPoint(x: 0, y: -Appearance.headerHeight)
    }

    // MARK: - Internal methods

    func initDataSource(
        with lesson: Lesson,
        nextLesson: Lesson?,
        nextLessonIsLocked: Bool
    ) {
        dataSource = LessonViewDataSource(
            lesson: lesson, nextLesson: nextLesson,
            nextLessonIsLocked: nextLessonIsLocked,
            tableView: tableView
        )
    }

    func displayLesson(_ viewModel: LessonViewModel) {
        headerView.updateContent(with: viewModel.lesson.backgroundImageUrl)
        headerView.setTitle(viewModel.lesson.title)
        dataSource?.updateData(lesson: viewModel.lesson, nextLesson: viewModel.nextLesson, nextLessonIsLocked: viewModel.nextLessonLocked == true)
    }

    public func updateHeaderWithScroll(offset: CGFloat, navBarHeight: CGFloat) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        headerView.updateAlphaChangingByScroll(
            currentPoint: offset + tableView.contentInset.top,
            startTurningWhitePoint: Appearance.navBarStartTurningPoint,
            turnСompletelyWhitePoint: Appearance.navBarTurnСompletelyTurnPoint
        )
        let minHeaderHeight: CGFloat = statusBarHeight + navBarHeight
        let height = max(offset > 0 ? 0 : -offset, minHeaderHeight)
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
        let realOffset = tableView.contentOffset.y + tableView.contentInset.top
        return realOffset > Appearance.navBarStartTurningPoint
    }
}
