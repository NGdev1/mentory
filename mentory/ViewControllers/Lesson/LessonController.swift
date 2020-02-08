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
            customView?.nextLessonCell?.playImageView.shake()
            return
        }
        customView?.scrollView.setContentOffset(.zero, animated: true)
        let result = delegate?.retrieveNextLesson(afrer: nextLesson)
        viewModel = LessonViewModel(
            lesson: nextLesson,
            nextLesson: result?.lesson,
            nextLessonLocked: result?.isLocked
        )
        customView?.displayLesson(viewModel)
    }
}

// MARK: - ViewControllerImageBasedAnimatable

extension LessonController: ViewControllerImageBasedAnimatable {
    public var actingView: ViewImageBasedAnimatable? {
        // swiftlint:disable unused_setter_value
        get { return customView } set {}
    }
}
