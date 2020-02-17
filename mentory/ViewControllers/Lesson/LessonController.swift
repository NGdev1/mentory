//
//  LessonController.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

final class LessonController: UIViewController {
    // MARK: - Properties

    lazy var customView: LessonView? = view as? LessonView
    var viewModel: LessonViewModel
    weak var delegate: MainPageControllerLogic?

    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let notificationsFeedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - Init

    init(viewModel: LessonViewModel, delegate: MainPageControllerLogic) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(
            nibName: Utils.getClassName(LessonView.self),
            bundle: Bundle(for: LessonView.self)
        )
        setupAppearance()
        addActionHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        extendedLayoutIncludesOpaqueBars = true
        customView?.displayLesson(viewModel)
        navigationItem.leftBarButtonItem = customView?.barButtonItem
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.backButton.addTarget(
            self,
            action: #selector(dismissController),
            for: .touchUpInside
        )
        customView?.playButton.addTarget(
            self,
            action: #selector(play),
            for: .touchUpInside
        )
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(nextLesson)
        )
        customView?.scrollView.delegate = self
        customView?.nextLessonCell?.contentView.addGestureRecognizer(tapRecognizer)
    }

    @objc func dismissController() {
        dismiss(animated: true)
    }

    @objc func play() {
        let nextController = PlayerController(lesson: viewModel.lesson)
        navigationController?.pushViewController(nextController)
    }

    @objc func nextLesson() {
        guard let nextLesson = viewModel.nextLesson else { return }
        guard viewModel.nextLessonLocked == false else {
            notificationsFeedbackGenerator.notificationOccurred(.error)
            customView?.nextLessonCell?.playImageView.shake()
            return
        }

        let result = delegate?.retrieveNextLesson(afrer: nextLesson)
        viewModel = LessonViewModel(
            lesson: nextLesson,
            nextLesson: result?.lesson,
            nextLessonLocked: result?.isLocked
        )
        customView?.scrollView.setContentOffset(
            CGPoint(x: 0, y: -LessonView.Appearance.headerHeight),
            animated: false
        )
        selectionFeedbackGenerator.selectionChanged()
        UIView.transition(
            with: customView ?? UIView(),
            duration: 0.4, options: .transitionCurlUp,
            animations: { [weak self] in
                guard let self = self else { return }
                self.customView?.displayLesson(self.viewModel)
            }, completion: nil
        )
    }
}

// MARK: - ViewControllerImageBasedAnimatable

extension LessonController: ViewControllerImageBasedAnimatable {
    public var actingView: ViewImageBasedAnimatable? {
        // swiftlint:disable unused_setter_value
        get { return customView } set {}
    }
}

// MARK: - UIScrollViewDelegate

extension LessonController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customView?.updateHeaderWithScroll(
            offset: scrollView.contentOffset,
            navBarHeight: navigationController?.navigationBar.height ?? 0
        )
    }
}
