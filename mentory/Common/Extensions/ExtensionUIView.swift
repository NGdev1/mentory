//
//  ExtensionUIView.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

extension UIView {
    func animateBorderWidth(toValue: CGFloat, duration: TimeInterval = 0.2) {
        let borderAnimation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderAnimation.fromValue = layer.borderWidth
        borderAnimation.toValue = toValue
        borderAnimation.duration = duration
        layer.add(borderAnimation, forKey: borderAnimation.keyPath)
        layer.borderWidth = toValue
    }
}
