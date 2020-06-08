//
//  ExtensionUIImage.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

extension UIImage {
    static func from(color: UIColor, rect: CGRect = .unit) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
