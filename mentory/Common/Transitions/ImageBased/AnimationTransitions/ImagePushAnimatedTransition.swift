//
//  ImagePushAnimatedTransition.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public final class ImagePushAnimatedTransition: NSObject {
    // MARK: - Properties

    public let animationDuration = 0.3
    public let smallerViewBorderRadius: CGFloat = 10
    public let transformScaleFactor: CGFloat = 0.7

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

        if let tabBarController = fromVC as? UITabBarController {
            fromVC = tabBarController.selectedViewController
        }
        if let navigationController = fromVC as? UINavigationController {
            fromVC = navigationController.viewControllers.last
        }
        if let navigationController = toVC as? UINavigationController {
            toVC = navigationController.viewControllers.first
        }

        let growingFromViewController = fromVC as? ViewControllerImageBasedAnimatable
        let growingToViewController = toVC as? ViewControllerImageBasedAnimatable
        let originStartView = growingFromViewController?.actingImageBasedView
        let originEndView = growingToViewController?.actingImageBasedView
        return ImageBasedContextTransitioning(
            isPushing: true,
            containerView: transitionContext.containerView,
            toViewController: toViewController,
            fromViewController: fromViewController,
            originStartView: originStartView,
            originEndView: originEndView
        )
    }

    private func applyStartAnimationStyle(using animating: ImageBasedContextTransitioning) {
        animating.containerView.backgroundColor = Assets.background1.color
        animating.actingView.contentMode = .scaleAspectFit
        animating.actingView.layer.cornerRadius = smallerViewBorderRadius
    }

    private func moveFinalViewToInvisibleArea(using animating: ImageBasedContextTransitioning) {
        animating.toController.view.frame = animating.toController.view.frame.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
    }

    // MARK: - Animation

    private func animate(
        using animating: ImageBasedContextTransitioning,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        let finalFrame = transitionContext.finalFrame(for: animating.toController)
        animating.actingView.frame = finalFrame
        animating.actingView.alpha = 0
        animating.fromController.view.alpha = 1
        UIView.animateKeyframes(
            withDuration: animationDuration,
            delay: 0,
            options: .calculationModeCubic,
            animations: { [weak self] in
                guard let self = self else { return }
                animating.actingView.alpha = 1
                animating.actingView.layer.cornerRadius = 0
                animating.fromController.view.transform = CGAffineTransform(
                    scaleX: self.transformScaleFactor,
                    y: self.transformScaleFactor
                )
                animating.fromController.view.alpha = 0
            },
            completion: { _ in
                animating.fromController.view.transform = .identity
                animating.toController.view.frame = finalFrame
                animating.actingView.removeFromSuperview()
                animating.actingImageView.removeFromSuperview()
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
            }
        )
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ImagePushAnimatedTransition: UIViewControllerAnimatedTransitioning {
    public var interactionController: UIPercentDrivenInteractiveTransition? {
        return nil
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let animating = initAnimating(using: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        // toView (view контроллера, который появляется) должен быть виден только в конце анимации.
        // toView нужно убрать с экрана, так как он не участвует в анимации, а участвует его скрин.
        // Если toView сделать isHidden, не удастся сделать его скриншот. Поэтому его приходится двигать туда, где не видно.
        moveFinalViewToInvisibleArea(using: animating)
        applyStartAnimationStyle(using: animating)
        animating.initContainerViewHierarchy()
        animate(using: animating, transitionContext: transitionContext)
    }
}
