//
//  ImagePopAnimatedTransition.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

final class ImagePopAnimatedTransition: NSObject {
    // MARK: - Properties

    var animating: ImageBasedContextTransitioning?
    var transitionContext: UIViewControllerContextTransitioning?

    let animationDuration = 0.4
    let smallerViewBorderRadius: CGFloat = 10
    let returnSizeAnimationDamping: CGFloat = 0.7

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
        let originStartView = growingFromViewController?.actingImageBasedView
        let originEndView = growingToViewController?.actingImageBasedView

        return ImageBasedContextTransitioning(
            isPushing: false,
            containerView: transitionContext.containerView,
            toViewController: toViewController,
            fromViewController: fromViewController,
            originStartView: originStartView,
            originEndView: originEndView
        )
    }

    func applyStartAnimationStyle() {
        guard let animating = animating else {
            return
        }
        animating.containerView.backgroundColor = Assets.background1.color
        animating.actingView.clipsToBounds = true
        animating.actingView.contentMode = .scaleAspectFill
        animating.actingImageView.contentMode = .scaleAspectFill
        animating.actingImageView.clipsToBounds = true
    }

    func hideReplacableBySnapshotsViews() {
        guard let animating = animating else {
            return
        }
        animating.fromController.view.isHidden = true
        animating.smallestView?.imageView.isHidden = true
    }

    func showReplacableBySnapshotsViews() {
        guard let animating = animating else {
            return
        }
        animating.fromController.view.isHidden = false
        animating.smallestView?.imageView.isHidden = false
    }

    // MARK: - Animation

    func update(translate: CGPoint, percent: CGFloat) {
        guard let animating = animating else { return }
        animating.actingView.cornerRadius = 50 * percent

        let newCenter = CGPoint(x: translate.x, y: translate.y)
        animating.actingImageView.frame.origin = newCenter
        animating.actingView.frame.origin = newCenter

        transitionContext?.updateInteractiveTransition(min(percent, 0.3))
    }
    
    func finishInteractiveTransition() {
        guard let animating = animating else { return }
    }
    
    func cancelIntaractiveTransition() {
        guard let animating = animating else { return }
    }

    private func animate(
        transitionContext: UIViewControllerContextTransitioning
    ) {
        guard let animating = animating else { transitionContext.completeTransition(false)
            return
        }
        let damping: CGFloat
        if transitionContext.isInteractive {
            damping = 1.0
        } else {
            damping = returnSizeAnimationDamping
        }

        // Нужно сохранить finalFrame, так как после преобразования scale он измениться.
        let finalFrame: CGRect = animating.smallestView?.imageView.globalFrame ?? CGRect.centerOfScreen
        animating.actingImageView.alpha = 0
        animating.toController.view.alpha = 1

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0.0,
            animations: { [weak self] in
                guard let self = self else { return }
                animating.actingImageView.frame = finalFrame
                // animating.actingView.frame = finalFrame
                animating.actingImageView.alpha = 1
                animating.actingView.alpha = 0
                animating.actingImageView.layer.cornerRadius = self.smallerViewBorderRadius
                animating.toController.view.alpha = 1
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.showReplacableBySnapshotsViews()
                animating.actingView.removeFromSuperview()
                animating.actingImageView.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    animating.toController.view.removeFromSuperview()
                }
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
            }
        )
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ImagePopAnimatedTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let animating = initAnimating(using: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        self.animating = animating
        applyStartAnimationStyle()
        hideReplacableBySnapshotsViews()
        animating.initContainerViewHierarchy()
        if transitionContext.isInteractive == false {
            animate(transitionContext: transitionContext)
        }
    }
}
