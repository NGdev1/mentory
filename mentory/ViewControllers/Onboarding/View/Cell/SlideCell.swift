//
//  SlideCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class SlideCell: UICollectionViewCell {
    // MARK: - Properties

    @IBOutlet var emojiImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        if ScreenSize.current == .sizeIPhoneSE {
            centerYConstraint.constant = 0
        }
    }

    // MARK: - Private methods

    private func createAttributedString(regularString: String, regularColor: UIColor, coloredString: String, color: UIColor) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "\(regularString)\(coloredString)")

        let regularTextRange = NSRange(location: 0, length: regularString.count)
        let coloredTextRange = NSRange(location: regularString.count, length: coloredString.count)
        let allTextRange = NSRange(location: 0, length: text.string.count)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4

        text.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: allTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: regularColor,
            range: regularTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: coloredTextRange
        )
        return text
    }

    // MARK: - Internal methods

    func configure(with slide: Slide) {
        emojiImageView.image = slide.image
        titleLabel.text = slide.title
        subtitleLabel.attributedText = createAttributedString(
            regularString: slide.subtitle,
            regularColor: Assets.title.color,
            coloredString: slide.highlitedText,
            color: Assets.winterGreen.color
        )
    }
}
