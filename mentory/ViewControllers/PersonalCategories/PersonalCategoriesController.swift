//
//  PersonalCategoriesController.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

protocol PersonalCategoriesControllerLogic: AnyObject {
    func didFinishRequest(_ data: [PersonalCategory])
    func presentError(message: String)
}

public class PersonalCategoriesController: UIViewController, PersonalCategoriesControllerLogic {
    // MARK: - Properties

    var interactor: PersonalCategoriesInteractor?

    lazy var customView: PersonalCategoriesView = PersonalCategoriesView()

    // MARK: - Init

    public init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        setupAppearance()
        addActionHandlers()
        loadCategories()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        interactor = PersonalCategoriesInteractor()
        interactor?.controller = self
    }

    private func setupAppearance() {
        // title = Text.PersonalCategories.title
    }

    // MARK: - Life cycle

    public override func loadView() {
        view = customView
    }

    // MARK: - Networking

    private func loadCategories() {
        interactor?.loadCategories()
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView.nextView.actionButton.addTarget(
            self,
            action: #selector(nextAction),
            for: .touchUpInside
        )
    }

    @objc func nextAction() {
        let nextController = MainPageController()
        AppDelegate.shared?.window?.rootViewController = nextController
    }

    // MARK: - PersonalCategoriesControllerLogic

    func didFinishRequest(_ data: [PersonalCategory]) {
        customView.stopShowingActivityIndicator()
        customView.updateData(data)
    }

    func presentError(message: String) {
        customView.stopShowingActivityIndicator()
        guard message != .empty else { return }
        let alert = AlertsFactory.plain(
            title: Text.Alert.error,
            message: message,
            cancelText: Text.Alert.cancel
        )
        present(alert, animated: true, completion: nil)
    }
}
