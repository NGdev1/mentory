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

    public override var inputAccessoryView: UIView? {
        return customView?.nextView
    }

    public override var canBecomeFirstResponder: Bool { true }

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
        customView?.nextView.actionButton.addTarget(
            self,
            action: #selector(nextAction),
            for: .touchUpInside
        )
    }

    @objc func nextAction() {}
}
