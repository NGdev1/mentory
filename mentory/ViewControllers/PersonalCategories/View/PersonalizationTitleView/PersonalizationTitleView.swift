//
//  PersonalizationTitleView.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

class PersonalizationTitleView: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        titleLabel.text = Text.PersonalCategories.title
        subtitleView.text = Text.PersonalCategories.subtitle
    }
}

public extension UICollectionReusableView {
    static var identifier: String {
        return Utils.getClassName(self)
    }

    static var nib: UINib {
        UINib(nibName: identifier, bundle: Bundle(for: self))
    }
}
