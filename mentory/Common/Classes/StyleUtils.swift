//
//  StyleUtils.swift
//  MD
//
//  Created by Михаил Андреичев on 24/07/2019.
//

import Foundation
import UIKit

let size320_568 = CGSize(width: 320, height: 568)
let size375_667 = CGSize(width: 375, height: 667)

public enum ScreenSize {
    case sizeIPhoneSE
    case sizeIPhone8
    case sizeIPhoneXOrLarger
    case sizeIPad

    public static var current: ScreenSize {
        let size = UIScreen.main.bounds.size
        if size.equalTo(size320_568) {
            return .sizeIPhoneSE
        } else if size.equalTo(size375_667) {
            return .sizeIPhone8
        } else if size.width < 500 {
            return .sizeIPhoneXOrLarger
        } else {
            return .sizeIPad
        }
    }
}
