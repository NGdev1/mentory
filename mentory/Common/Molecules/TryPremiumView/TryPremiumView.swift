//
//  TryPremiumView.swift
//  mentory
//
//  Created by Михаил Андреичев on 12.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class TryPremiumView: UIView {
    // MARK: - Properties

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        setupStyle()
    }

    private func setupStyle() {
        backgroundColor = Assets.black.color
        titleLabel.text = Text.MainPage.getPremium
        subtitleLabel.text = Text.MainPage.pressForInfo
    }
}
