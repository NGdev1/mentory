//
//  NameController.swift
//  Mentory
//
//  Created by Михаил Андреичев on 16.12.2019.
//

import MDFoundation
import UIKit

public class NameController: UIViewController {
    // MARK: - Properties

    lazy var customView: NameView? = view as? NameView

    // MARK: - Init

    public init() {
        super.init(
            nibName: Utils.getClassName(NameView.self),
            bundle: Bundle(for: NameView.self)
        )
        setupAppearance()
        addActionHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {}

    // MARK: - ActionHandlers

    private func addActionHandlers() {
        customView?.nextButton.addTarget(
            self,
            action: #selector(nextAction),
            for: .touchUpInside
        )
        customView?.backButton.addTargetForAction(
            self,
            action: #selector(backAction)
        )
    }

    @objc func backAction() {}

    @objc func nextAction() {}
}
