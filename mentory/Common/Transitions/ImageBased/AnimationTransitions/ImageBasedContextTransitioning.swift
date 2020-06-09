//
//  ImageBasedContextTransitioning.swift. Действующие при анимации объекты
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//
//
// Анимация шага вперед (push):
//      fromController                            toController
// +—————————————————————+                    +————————————————————+
// |     fromView        |                    |                    |
// |  +———————————————+  |                    |                    |
// |  |               |  |                    |      toView,       |
// |  | smallestView  |  | fromView -> toView |       он же        |
// |  |originStartView|  |                    |     biggerView,    |
// |  +———————————————+  |                    |   originEndView    |
// |                     |                    |                    |
// +—————————————————————+                    +————————————————————+
//
// Анимация шага назад (pop):
//      fromController                             toController
// +————————————————————+                     +————————————————————+
// |                    |                     |       toView       |
// |                    |                     |  +——————————————+  |
// |      fromView,     |                     |  |              |  |
// |       он же        | fromView -> toView  |  | smallestView |  |
// |     biggerView,    |                     |  |originEndView |  |
// |  originStartView   |                     |  +——————————————+  |
// |                    |                     |                    |
// +————————————————————+                     +————————————————————+
//
// В видимой анимации участвуют скриншоты.
// Для того, чтобы скрин toView получился, нужно инициализировать его не с нулевым frame.

import UIKit

/// Действующие при анимации объекты
public class ImageBasedContextTransitioning {
    // MARK: - Properties

    /// Родительский view
    let containerView: UIView

    /// View Controller, который требуется показать в результате анимации:
    let toController: UIViewController

    /// View Controller, с которого все начинается:
    let fromController: UIViewController

    /// View большего размера (на весь экран), который будет показан в резальтате выполнения анимации, или исчезнет, уменьшаясь до маленького.
    /// В случае шага вперед (push) - toController.view
    /// В случае шага назад (pop) - fromController.view
    let biggerView: ViewImageBasedAnimatable?

    /// View меньшего размера. Главный view должен уменьшится до его размера и певратиться в него.
    /// В случае шага вперед (push) - fromController.view
    /// В случае шага назад (pop) - toController.view
    let smallestView: ViewImageBasedAnimatable?

    /// Анимируемый imageView. Этот элемент всегда находится выше в иерархии, чем другой imageView
    /// В случае шага вперед (push) - скрин toView.imageView.
    /// В случае шага назад (pop) - скрин fromView.imageView.
    let actingView: UIView

    let actingImageView: UIView

    // MARK: - Init

    internal init(
        isPushing: Bool,
        containerView: UIView,
        toViewController: UIViewController,
        fromViewController: UIViewController,
        originStartView: ViewImageBasedAnimatable?,
        originEndView: ViewImageBasedAnimatable?
    ) {
        self.toController = toViewController
        self.fromController = fromViewController
        self.containerView = containerView

        if isPushing {
            self.biggerView = originEndView
            self.smallestView = originStartView
            self.actingView = toViewController.view.snapshotView(afterScreenUpdates: true) ?? UIView()
            self.actingImageView = UIImageView(image: originStartView?.imageView.image)
            initPushFrames()
        } else { // Pop
            self.biggerView = originStartView
            self.smallestView = originEndView
            self.actingView = fromViewController.view.snapshotView(afterScreenUpdates: false) ?? UIView()
            self.actingImageView = UIImageView(image: originEndView?.imageView.image)
            initPopFrames()
        }
        actingImageView.backgroundColor = Assets.background1.color
    }

    public func initPopFrames() {
        actingImageView.frame = biggerView?.imageView.frame ?? .zero
        actingView.frame = fromController.view.frame
    }

    public func initPushFrames() {
        actingImageView.frame = smallestView?.imageView.globalFrame ?? .zero
        actingView.frame = smallestView?.imageView.globalFrame ?? .zero
    }

    public func initContainerViewHierarchy() {
        containerView.addSubview(toController.view)
        containerView.addSubview(actingView)
        containerView.addSubview(actingImageView)
    }
}
