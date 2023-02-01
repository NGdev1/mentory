//
//  SwipeInteractionController.swift
//  Pods
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public final class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    public var interactionInProgress = false

    var popAnimationController: ImagePopAnimatedTransition?
    var transitionContext: UIViewControllerContextTransitioning?

    private let transitionShouldCompleteIfProgressMoreThan: CGFloat = 0.5
    private let transitionShouldCompleteIfVelocityMoreThan: CGFloat = 200
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
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }

    override public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
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

    private func customUpdate(translate: CGPoint, percent: CGFloat) {
        if popAnimationController == nil {
            update(percent); return
        }
        popAnimationController?.update(translate: translate, percent: percent)
    }

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translate = gestureRecognizer.translation(in: gestureRecognizer.view)
        let percent = abs(translate.y) / (gestureRecognizer.view!.bounds.size.height / 2)

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            startDismissTransition()
        case .changed:
            let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
            shouldCompleteTransition =
                percent > transitionShouldCompleteIfProgressMoreThan ||
                abs(velocity.y) > transitionShouldCompleteIfVelocityMoreThan
            customUpdate(translate: translate, percent: percent)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                if popAnimationController == nil {
                    finish(); return
                }
                popAnimationController?.finishInteractiveTransition()
            } else {
                if popAnimationController == nil {
                    cancel(); return
                }
                popAnimationController?.cancelIntaractiveTransition()
            }
        default:
            break
        }
    }
}
