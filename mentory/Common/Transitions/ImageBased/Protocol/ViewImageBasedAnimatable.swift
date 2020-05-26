//
//  ViewImageBasedAnimatable.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public protocol ViewImageBasedAnimatable where Self: UIView {
    var imageView: UIImageView { get }
}

public protocol ViewControllerImageBasedAnimatable where Self: UIViewController {
    var actingImageBasedView: ViewImageBasedAnimatable? { get set }
}
