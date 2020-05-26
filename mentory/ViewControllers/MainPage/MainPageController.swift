//
//  MainPageController.swift
//  mentory
//
//  Created by Михаил Андреичев on 05.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import Storable
import UIKit

protocol MainPageControllerLogic: AnyObject {
    func presentData(_ viewModels: [MainPageCellViewModel])
    func presentError(message: String)
    func retrieveNextLesson(afrer lesson: Lesson) -> NextLessonRetrievingResult?
    func retrievePreviousStory(before story: Story) -> StoryRetrievingResult?
    func retrieveNextStory(after story: Story) -> StoryRetrievingResult?
}

class MainPageController: UIViewController, MainPageControllerLogic {
    // MARK: - Properties

    lazy var customView = MainPageView()
    var interactor: MainPageInteractor?
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let notificationsFeedbackGenerator = UINotificationFeedbackGenerator()
    private var growingLessonView: ViewLessonAnimatable?
    private var growingImageBasedView: ViewImageBasedAnimatable?
    private lazy var lessonTransitionManager = LessonTransitionManager()
    private lazy var imageBasedTransitionManager = ImageBasedTransitionManager()

    // MARK: - Life cycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAppearance()
        addActionHandlers()
        loadLessons()
    }

    private func setup() {
        interactor = MainPageInteractor()
        interactor?.controller = self
    }

    private func setupAppearance() {
        customView.initDataSource()
        customView.dataSource?.delegate = self

        if AppService.shared.app.appOpenedCount > 3,
            AppService.shared.app.appState == .free {
            showPurchasePage()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appStateChanged),
            name: .appStateChanged,
            object: nil
        )
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(showPurchasePage)
        )
        customView.tryPremiumView.isUserInteractionEnabled = true
        customView.tryPremiumView.addGestureRecognizer(tapRecognizer)
    }

    @objc func appStateChanged() {
        if AppService.shared.app.appState == .premium {
            let alert = AlertsFactory.plain(
                title: Text.Buy.congragulations,
                message: Text.Buy.success,
                cancelText: Text.Buy.done
            )
            present(alert, animated: true, completion: nil)
            customView.hideBottomView()
        }
        loadLessons()
    }

    // MARK: - Network requests

    private func loadLessons() {
        // customView.startShowingActivityIndicator()
        interactor?.loadData()
    }

    // MARK: - MainPageControllerLogic

    func presentData(_ viewModels: [MainPageCellViewModel]) {
        customView.updateAppearance(with: viewModels)
    }

    func retrieveNextStory(after story: Story) -> StoryRetrievingResult? {
        let result = customView.dataSource?.getNextStory(after: story)
        growingImageBasedView = result?.cellView
        return result
    }

    func retrievePreviousStory(before story: Story) -> StoryRetrievingResult? {
        let result = customView.dataSource?.getPreviousStory(before: story)
        growingImageBasedView = result?.cellView
        return result
    }

    func retrieveNextLesson(afrer lesson: Lesson) -> NextLessonRetrievingResult? {
        let result = customView.dataSource?.getNextLesson(after: lesson)
        actingLessonView = result?.cellView
        return result
    }

    func presentError(message: String) {
        customView.showEmptyPage()
        // customView.stopShowingActivityIndicator()
        guard message != .empty else { return }
        let alert = AlertsFactory.plain(
            title: Text.Alert.error,
            message: message,
            cancelText: Text.Alert.cancel
        )
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MainPageDataSourceDelegate

extension MainPageController: MainPageDataSourceDelegate {
    func showStory(_ story: Story, view: StoryCell?) {
        actingImageBasedView = view
        let nextController = StoriesFullScreenController(story: story, delegate: self)
        nextController.transitioningDelegate = imageBasedTransitionManager
        nextController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(nextController, animated: true)
        }
    }

    func displayLesson(
        _ lesson: Lesson,
        lessonIsLocked: Bool,
        nextLesson: Lesson?,
        nextLessonIsLocked: Bool?,
        cellView: LessonCell?
    ) {
        guard lessonIsLocked == false else {
            notificationsFeedbackGenerator.notificationOccurred(.error)
            showPurchasePage()
            return
        }

        actingLessonView = cellView
        let viewModel = LessonViewModel(
            lesson: lesson,
            nextLesson: nextLesson,
            nextLessonLocked: nextLessonIsLocked
        )
        let nextController = LessonController(viewModel: viewModel, delegate: self)
        let navigationController = UINavigationController(rootViewController: nextController)
        navigationController.view.backgroundColor = Assets.background1.color
        navigationController.navigationBar.setTransparentAppearance()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.transitioningDelegate = lessonTransitionManager
        selectionFeedbackGenerator.selectionChanged()
        DispatchQueue.main.async { [weak self] in
            self?.present(navigationController, animated: true)
        }
    }

    @objc func showPurchasePage() {
        let nextController = BuyController()
        nextController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(nextController, animated: true)
        }
    }
}

// MARK: - ViewControllerLessonAnimatable

extension MainPageController: ViewControllerLessonAnimatable {
    public var actingLessonView: ViewLessonAnimatable? {
        get { return growingLessonView }
        set(newValue) { growingLessonView = newValue }
    }
}

// MARK: - ViewControllerImageBasedAnimatable

extension MainPageController: ViewControllerImageBasedAnimatable {
    public var actingImageBasedView: ViewImageBasedAnimatable? {
        get { return growingImageBasedView }
        set(newValue) { growingImageBasedView = newValue }
    }
}
