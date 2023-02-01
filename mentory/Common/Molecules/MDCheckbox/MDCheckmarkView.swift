//
//  MDCheckmarkView.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class MDCheckmarkView: UIView {
    // MARK: - Properties

    var color: UIColor = .blue

    fileprivate var animationDuration: TimeInterval = 0.275
    var strokeWidth: CGFloat = 0

    fileprivate var checkmarkLayer: CAShapeLayer!

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckmark()
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckmark()
    }

    fileprivate func setupCheckmark() {
        checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = nil

        layer.addSublayer(checkmarkLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: bounds.width * 0.28, y: bounds.height * 0.5))
        checkmarkPath.addLine(to: CGPoint(x: bounds.width * 0.42, y: bounds.height * 0.66))
        checkmarkPath.addLine(to: CGPoint(x: bounds.width * 0.72, y: bounds.height * 0.36))
        checkmarkPath.lineCapStyle = .square
        checkmarkLayer.path = checkmarkPath.cgPath
    }

    // MARK: - Internal methods

    func show(_ animated: Bool = true) {
        // checkmarkLayer.removeAllAnimations()
        checkmarkLayer.opacity = 1
        checkmarkLayer.strokeColor = color.cgColor
        checkmarkLayer.lineWidth = strokeWidth

        if animated == false {
            checkmarkLayer.strokeEnd = 1
        } else {
            let checkmarkAnimation: CABasicAnimation = .init(keyPath: "strokeEnd")
            checkmarkAnimation.duration = animationDuration
            checkmarkAnimation.isRemovedOnCompletion = false
            checkmarkAnimation.fillMode = CAMediaTimingFillMode.forwards
            checkmarkAnimation.fromValue = 0
            checkmarkAnimation.toValue = 1
            checkmarkAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            checkmarkLayer.add(checkmarkAnimation, forKey: "strokeEnd")
        }
    }

    func hide(_ animated: Bool = true) {
        if animated == false {
            checkmarkLayer.strokeEnd = 0
            return
        }

        // checkmarkLayer.removeAllAnimations()
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.duration = animationDuration
        checkmarkAnimation.isRemovedOnCompletion = false
        checkmarkAnimation.fillMode = CAMediaTimingFillMode.forwards
        checkmarkAnimation.fromValue = 1
        checkmarkAnimation.toValue = 0
        checkmarkAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        checkmarkLayer.add(checkmarkAnimation, forKey: "strokeEnd")
    }
}
