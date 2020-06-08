//
//  ScreenEdgeInteractionController.swift
//  Pods
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public final class ScreenEdgeInteractionController: UIPercentDrivenInteractiveTransition {
    public var interactionInProgress = false

    private let transitionShouldCompleteIfProgressMoreThan: CGFloat = 0.5
    private let transitionShouldCompleteIfVelocityMoreThan: CGFloat = 0.2
    private var shouldCompleteTransition = false
    private var shouldPopViewController = false
    private var dismissFunc: (() -> Void)?
    public var viewController: UIViewController
    public var navigationController: UINavigationController?

    public init(
        viewController: UIViewController,
        navigationController: UINavigationController? = nil,
        shouldPopViewController: Bool = false,
        dismissFunc: (() -> Void)? = nil
    ) {
        self.dismissFunc = dismissFunc
        self.viewController = viewController
        self.navigationController = navigationController
        self.shouldPopViewController = shouldPopViewController
        super.init()
        prepareGestureRecognizer(in: viewController.view)
    }

    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }

    private func startDismissTransition() {
        guard let dismiss = dismissFunc else {
            if let navigationController = navigationController {
                if shouldPopViewController {
                    navigationController.popViewController()
                } else {
                    navigationController.dismiss(animated: true)
                }
            } else {
                viewController.dismiss(animated: true)
            }
            return
        }
        dismiss()
    }

    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translate = gestureRecognizer.translation(in: gestureRecognizer.view)
        let percent = translate.x / gestureRecognizer.view!.bounds.size.width

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            startDismissTransition()
        case .changed:
            let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
            shouldCompleteTransition =
                percent > transitionShouldCompleteIfProgressMoreThan ||
                velocity.x > transitionShouldCompleteIfVelocityMoreThan
            update(percent)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
