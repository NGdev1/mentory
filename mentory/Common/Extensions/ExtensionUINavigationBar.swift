//
//  ExtensionUINavigationBar.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationBar {
    func setBaseAppearance() {
        setBackgroundImage(nil, for: .default)
        hideShadow(false)
        barTintColor = Assets.background1.color
        tintColor = Assets.warmGrey.color
    }

    func setTransparentAppearance() {
        setBackgroundImage(UIImage(), for: .default)
        hideShadow(true)
        barTintColor = .clear
        tintColor = Assets.warmGrey.color
    }

    func setBackButtonImage() {
        // backIndicatorTransitionMaskImage = Images.iconBack.image
        // backIndicatorImage = Images.iconBack.image
    }
}
