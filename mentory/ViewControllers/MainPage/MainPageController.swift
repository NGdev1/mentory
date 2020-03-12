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
    func presenLessons(_ lessons: [MainPageCellViewModel])
    func presentError(message: String)
    func retrieveNextLesson(afrer lesson: Lesson) -> NextLessonRetrievingResult?
}

class MainPageController: UIViewController, MainPageControllerLogic {
    // MARK: - Properties

    lazy var customView = MainPageView()
    var interactor: MainPageInteractor?
    var presenter: MainPagePresenter?
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let notificationsFeedbackGenerator = UINotificationFeedbackGenerator()
    private var growingAnimatableView: ViewImageBasedAnimatable?
    private var transitionManager = ImageBasedTransitionManager()

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
        let controller = self
        interactor = MainPageInteractor()
        presenter = MainPagePresenter()
        interactor?.presenter = presenter
        presenter?.controller = controller
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

    func presenLessons(_ lessons: [MainPageCellViewModel]) {
        customView.updateAppearance(with: lessons)
    }

    func retrieveNextLesson(afrer lesson: Lesson) -> NextLessonRetrievingResult? {
        let result = customView.dataSource?.getNextLesson(after: lesson)
        actingView = result?.cellView
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

        actingView = cellView
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
        navigationController.transitioningDelegate = transitionManager
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

// MARK: - ViewControllerImageBasedAnimatable

extension MainPageController: ViewControllerImageBasedAnimatable {
    public var actingView: ViewImageBasedAnimatable? {
        get { return growingAnimatableView }
        set(newValue) { growingAnimatableView = newValue }
    }
}
