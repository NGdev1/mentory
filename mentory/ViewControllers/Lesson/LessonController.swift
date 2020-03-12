//
//  LessonController.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import Storable
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
        customView?.initDataSource(
            with: viewModel.lesson,
            nextLesson: viewModel.nextLesson,
            nextLessonIsLocked: viewModel.nextLessonLocked == true
        )
        customView?.dataSource?.delegate = self
    }

    // MARK: - Private methods

    func showPurchasePage() {
        let nextController = BuyController()
        nextController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(nextController, animated: true)
        }
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
    }

    @objc func dismissController() {
        dismiss(animated: true)
    }

    @objc func play() {
        guard viewModel.lesson.tracks.isEmpty == false else { return }
        guard viewModel.lesson.tracks[0].isLocked == false else {
            showPurchasePage()
            return
        }
        let nextController = PlayerController(lesson: viewModel.lesson, startIndex: 0)
        navigationController?.pushViewController(nextController)
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

extension LessonController: LessonViewDataSourceDelegate {
    func didScroll(offset: CGFloat) {
        customView?.updateHeaderWithScroll(
            offset: offset,
            navBarHeight: navigationController?.navigationBar.height ?? 0
        )
    }

    func playTrack(with index: Int) {
        guard viewModel.lesson.tracks[index].isLocked == false || AppService.shared.app.appState == .premium else {
            showPurchasePage()
            return
        }
        let nextController = PlayerController(lesson: viewModel.lesson, startIndex: index)
        navigationController?.pushViewController(nextController)
    }

    func nextLesson() {
        guard let nextLesson = viewModel.nextLesson else { return }
        let result = delegate?.retrieveNextLesson(afrer: nextLesson)
        viewModel = LessonViewModel(
            lesson: nextLesson,
            nextLesson: result?.lesson,
            nextLessonLocked: result?.isLocked
        )
        customView?.tableView.setContentOffset(
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
