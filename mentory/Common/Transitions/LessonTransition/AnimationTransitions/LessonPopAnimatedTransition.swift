//
//  LessonPopAnimatedTransition.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public final class LessonPopAnimatedTransition: NSObject {
    // MARK: - Properties

    public let animationDuration = 0.3
    public let smallerViewBorderRadius: CGFloat = 10
    public let transformScaleFactor: CGFloat = 0.9

    // MARK: - Init

    private func initAnimating(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> LessonContextTransitioning? {
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

        let growingFromViewController = fromVC as? ViewControllerLessonAnimatable
        let growingToViewController = toVC as? ViewControllerLessonAnimatable
        let originStartView = growingFromViewController?.actingLessonView
        let originEndView = growingToViewController?.actingLessonView

        return LessonContextTransitioning(
            isPushing: false,
            containerView: transitionContext.containerView,
            toViewController: toViewController,
            fromViewController: fromViewController,
            originStartView: originStartView,
            originEndView: originEndView
        )
    }

    private func applyStartAnimationStyle(using animating: LessonContextTransitioning) {
        animating.containerView.backgroundColor = Assets.background1.color
        animating.actingControllerSnapshot.contentMode = .scaleAspectFill
        animating.actingControllerSnapshot.layer.masksToBounds = true
        animating.actingImageViewGradient.contentMode = .scaleToFill
        animating.actingImageViewGradient.alpha = 0
        animating.actingImageView.contentMode = .scaleAspectFill
        animating.actingImageView.layer.masksToBounds = true
    }

    func hideReplacableBySnapshotsViews(using animating: LessonContextTransitioning) {
        animating.fromView.isHidden = true
        animating.smallestView?.imageView.isHidden = true
    }

    func showReplacableBySnapshotsViews(using animating: LessonContextTransitioning) {
        animating.fromView.isHidden = false
        animating.smallestView?.imageView.isHidden = false
    }

    // MARK: - Animation

    private func animate(
        using animating: LessonContextTransitioning,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        // Нужно сохранить finalFrame, так как после преобразования scale он измениться.
        let finalFrame: CGRect = animating.smallestView?.imageView.globalFrame ?? CGRect.centerOfScreen
        animating.toView.transform = CGAffineTransform(scaleX: transformScaleFactor, y: transformScaleFactor)
        UIView.animate(
            withDuration: animationDuration,
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

extension LessonPopAnimatedTransition: UIViewControllerAnimatedTransitioning {
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
