//
//  NameController.swift
//  Mentory
//
//  Created by Михаил Андреичев on 16.12.2019.
//

import MDFoundation
import Storable
import UIKit

public class NameController: UIViewController {
    // MARK: - Properties

    lazy var customView: NameView? = view as? NameView

    override public var inputAccessoryView: UIView? {
        return customView?.nextView
    }

    override public var canBecomeFirstResponder: Bool { true }

    // MARK: - Init

    public init() {
        super.init(
            nibName: Utils.getClassName(NameView.self),
            bundle: Bundle(for: NameView.self)
        )
        setupAppearance()
        addActionHandlers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {}

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.nextView.actionButton.addTarget(
            self,
            action: #selector(nextAction),
            for: .touchUpInside
        )
    }

    @objc func nextAction() {
        guard let name = customView?.nameTextField.text, name.count > 3 else {
            customView?.nameTextField.shake()
            return
        }
        AppService.shared.app.userName = name
        let nextController = PersonalCategoriesController()
        AppDelegate.shared?.window?.rootViewController = nextController
    }
}
