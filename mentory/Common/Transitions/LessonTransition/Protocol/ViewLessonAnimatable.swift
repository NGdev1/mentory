//
//  ViewLessonAnimatable.swift
//
//  Created by Михаил Андреичев on 06.02.2020.
//  Copyright © 2020 MD. All rights reserved.
//

import UIKit

public protocol ViewLessonAnimatable where Self: UIView {
    var mainView: UIView { get }
    var imageView: UIImageView { get }
    var isImageDisappeared: Bool { get }
}

public protocol ViewControllerLessonAnimatable where Self: UIViewController {
    var actingLessonView: ViewLessonAnimatable? { get set }
}
