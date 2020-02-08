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
public struct ImageBasedContextTransitioning {
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

    /// View, на котором анимация завершится.
    /// В случае шага вперед (push) - это view большего размера (на весь экран), который будет показан в резальтате выполнения анимации. В этом случае toView = biggerView
    /// В случае шага назад (pop) - это view меньшего размера. Тогда главный view должен уменьшится до его размера и певратиться в него. В этом случае toView = smallestView
    let toView: UIView

    /// View, c которого анимация начинается.
    /// В случае шага вперед (push) - это view меньшего размера. Тогда главный view должен уменьшится до его размера и певратиться в него. В этом случае toView = smallestView
    /// В случае шага назад (pop) - это view большего размера (на весь экран), который будет показан в резальтате выполнения анимации. В этом случае toView = biggerView
    let fromView: UIView

    /// Скрин view появляемого или исчезаемого ViewController. Этот контроллер всегда находится выше в иерархии
    /// В случае шага вперед (push) - скрин toView.
    /// В случае шага назад (pop) - скрин fromView.
    let actingControllerSnapshot: UIView

    /// Анимируемый imageView. Этот элемент всегда находится выше в иерархии, чем другой imageView
    /// В случае шага вперед (push) - скрин toView.imageView.
    /// В случае шага назад (pop) - скрин fromView.imageView.
    let actingImageView: UIView

    /// Эффект blur, используется только при переходе назад - при свайпе с левой части экрана.
    var blurView: UIVisualEffectView?

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
            self.toView = toController.view
            self.fromView = fromController.view
            self.actingControllerSnapshot = toView.snapshotView(afterScreenUpdates: true) ?? UIView()
            self.actingImageView = UIImageView(image: originStartView?.imageView.image)
            initPushFrames()
        } else { // Pop
            self.biggerView = originStartView
            self.smallestView = originEndView
            self.toView = toController.view
            self.fromView = fromController.view
            self.actingControllerSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
            self.actingImageView = UIImageView(image: originEndView?.imageView.image)
            initPopFrames()
        }
    }

    public func initPopFrames() {
        actingControllerSnapshot.frame = biggerView?.mainView.frame ?? UIScreen.main.bounds
        actingImageView.frame = biggerView?.imageView.frame ?? .zero
        if biggerView?.isImageDisappeared ?? false {
            actingImageView.frame = actingImageView.frame.with(height: 0)
        }
    }

    public func initPushFrames() {
        actingControllerSnapshot.frame = smallestView?.imageView.globalFrame ?? .centerOfScreen
        actingImageView.frame = smallestView?.imageView.globalFrame ?? .zero
    }

    public mutating func initBlurEffect() {
        let effect = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: effect)
        blurView?.frame = UIScreen.main.bounds
    }

    public func initContainerViewHierarchy() {
        containerView.addSubview(toView)
        if let blurView = blurView {
            containerView.addSubview(blurView)
        }
        containerView.addSubview(actingControllerSnapshot)
        containerView.addSubview(actingImageView)
    }
}
