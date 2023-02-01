//
//  ImageBasedTransitionManager.swift
//  General
//
//  Created by Михаил Андреичев on 07.02.2020.
//

import UIKit

public final class ImageBasedTransitionManager: NSObject {
    var customInteractor: SwipeInteractionController?
}

// MARK: - UINavigationControllerDelegate

extension ImageBasedTransitionManager: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            customInteractor = SwipeInteractionController(viewController: toVC)
            return ImagePushAnimatedTransition()
        case .pop:
            return ImagePopAnimatedTransition()
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

extension ImageBasedTransitionManager: UIViewControllerTransitioningDelegate {
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ImagePopAnimatedTransition()
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if let navigationController = presented as? UINavigationController,
           let controller = navigationController.viewControllers.last
        {
            customInteractor = SwipeInteractionController(viewController: controller)
            return ImagePushAnimatedTransition()
        }
        customInteractor = SwipeInteractionController(viewController: presented)
        return ImagePushAnimatedTransition()
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        customInteractor?.popAnimationController = animator as? ImagePopAnimatedTransition
        return (customInteractor?.interactionInProgress ?? false) ? customInteractor : nil
    }
}
