//
//  ImagePopAnimatedTransition.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public final class ImagePopAnimatedTransition: NSObject {
    // MARK: - Properties

    public let animationDuration = 0.5
    public let smallerViewBorderRadius: CGFloat = 10
    public let transformScaleFactor: CGFloat = 0.9
    public let returnSizeAnimationDamping: CGFloat = 0.7

    // MARK: - Init

    private func initAnimating(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> ImageBasedContextTransitioning? {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else { return nil }

        var fromVC: UIViewController? = fromViewController
        var toVC: UIViewController? = toViewController

        if let navigationController = fromVC as? UINavigationController {
            fromVC = navigationController.viewControllers.first
        }
        if let tabBarController = toVC as? UITabBarController {
            toVC = tabBarController.selectedViewController
        }
        if let navigationController = toVC as? UINavigationController {
            toVC = navigationController.viewControllers.last
        }

        let growingFromViewController = fromVC as? ViewControllerImageBasedAnimatable
        let growingToViewController = toVC as? ViewControllerImageBasedAnimatable
        let originStartView = growingFromViewController?.actingView
        let originEndView = growingToViewController?.actingView

        return ImageBasedContextTransitioning(
            isPushing: false,
            containerView: transitionContext.containerView,
            toViewController: toViewController,
            fromViewController: fromViewController,
            originStartView: originStartView,
            originEndView: originEndView
        )
    }

    private func applyStartAnimationStyle(using animating: ImageBasedContextTransitioning) {
        animating.containerView.backgroundColor = Assets.black.color
        animating.actingControllerSnapshot.contentMode = .scaleAspectFill
        animating.actingControllerSnapshot.layer.masksToBounds = true
        animating.actingImageViewGradient.contentMode = .scaleToFill
        animating.actingImageViewGradient.alpha = 0
        animating.actingImageView.contentMode = .scaleAspectFill
        animating.actingImageView.layer.masksToBounds = true
    }

    func hideReplacableBySnapshotsViews(using animating: ImageBasedContextTransitioning) {
        animating.fromView.isHidden = true
        animating.smallestView?.imageView.isHidden = true
    }

    func showReplacableBySnapshotsViews(using animating: ImageBasedContextTransitioning) {
        animating.fromView.isHidden = false
        animating.smallestView?.imageView.isHidden = false
    }

    // MARK: - Animation

    private func animate(
        using animating: ImageBasedContextTransitioning,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        let damping: CGFloat
        if transitionContext.isInteractive {
            damping = 1.0
        } else {
            damping = returnSizeAnimationDamping
        }

        // Нужно сохранить finalFrame, так как после преобразования scale он измениться.
        let finalFrame: CGRect = animating.smallestView?.imageView.globalFrame ?? CGRect.centerOfScreen
        animating.toView.transform = CGAffineTransform(scaleX: transformScaleFactor, y: transformScaleFactor)
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0.0,
            animations: { [weak self] in
                guard let self = self else { return }
                animating.actingImageView.frame = finalFrame
                animating.actingImageView.layer.cornerRadius = self.smallerViewBorderRadius
                animating.actingControllerSnapshot.frame = finalFrame
                animating.actingImageViewGradient.frame = finalFrame
                animating.actingImageViewGradient.alpha = 1
                animating.actingControllerSnapshot.layer.cornerRadius = self.smallerViewBorderRadius
                animating.toView.transform = .identity
                animating.blurView?.effect = nil
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.showReplacableBySnapshotsViews(using: animating)
                animating.actingControllerSnapshot.removeFromSuperview()
                animating.actingImageView.removeFromSuperview()
                animating.actingImageViewGradient.removeFromSuperview()
                animating.blurView?.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    animating.toView.removeFromSuperview()
                }
                animating.toView.transform = .identity
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
            }
        )
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ImagePopAnimatedTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard var animating = initAnimating(using: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        applyStartAnimationStyle(using: animating)
        hideReplacableBySnapshotsViews(using: animating)
        if transitionContext.isInteractive {
            animating.initBlurEffect()
        }
        animating.initContainerViewHierarchy()
        animate(using: animating, transitionContext: transitionContext)
    }
}
