//
//  BuyController.swift
//  mentory
//
//  Created by Михаил Андреичев on 26.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation

protocol BuyControllerLogic: AnyObject {
    func presentError(message: String)
}

public class BuyController: UIViewController, BuyControllerLogic {
    // MARK: - Properties

    var interactor: BuyInteractor?
    lazy var customView: BuyView? = view as? BuyView
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Init

    public init() {
        super.init(
            nibName: Utils.getClassName(BuyView.self),
            bundle: Bundle(for: BuyView.self)
        )
        setup()
        addActionHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        interactor = BuyInteractor()
        interactor?.controller = self
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside
        )
        customView?.delegate = self
    }

    @objc func close() {
        dismiss(animated: true)
    }

    // MARK: - BuyControllerLogic

    func presentError(message: String) {
        customView?.stopShowingActivityIndicator()
        guard message != .empty else { return }
        let alert = AlertsFactory.error(
            title: Text.Alert.error,
            message: message,
            cancelText: Text.Alert.cancel
        )
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - BuyViewDelegate

extension BuyController: BuyViewDelegate {
    func planChanged(state: BuyView.State) {
        selectionFeedbackGenerator.selectionChanged()
    }
}
