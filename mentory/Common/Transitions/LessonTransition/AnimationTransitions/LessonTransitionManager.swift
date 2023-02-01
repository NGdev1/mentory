//
//  LessonTransitionManager.swift
//  SharedComponents
//
//  Created by Михаил Андреичев on 07.02.2020.
//

import UIKit

public final class LessonTransitionManager: NSObject {
    var customInteractor: ScreenEdgeInteractionController?
}

// MARK: - UINavigationControllerDelegate

extension LessonTransitionManager: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            customInteractor = ScreenEdgeInteractionController(viewController: toVC)
            return LessonPushAnimatedTransition()
        case .pop:
            return LessonPopAnimatedTransition()
        case .none:
            return nil
        @unknown default:
            return nil
        }
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return (customInteractor?.interactionInProgress ?? false) ? customInteractor : nil
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension LessonTransitionManager: UIViewControllerTransitioningDelegate {
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return LessonPopAnimatedTransition()
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if let navigationController = presented as? UINavigationController,
           let controller = navigationController.viewControllers.last
        {
            customInteractor = ScreenEdgeInteractionController(viewController: controller)
            return LessonPushAnimatedTransition()
        }
        customInteractor = ScreenEdgeInteractionController(viewController: presented)
        return LessonPushAnimatedTransition()
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return (customInteractor?.interactionInProgress ?? false) ? customInteractor : nil
    }
}
