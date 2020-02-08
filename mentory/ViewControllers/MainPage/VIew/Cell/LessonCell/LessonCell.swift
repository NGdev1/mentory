//
//  LessonCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playImageView: UIImageView!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
    }

    // MARK: - Internal methods

    func configure(with lesson: Lesson, isLocked: Bool) {
        titleLabel.text = lesson.title
        subtitleLabel.text = lesson.subtitle
        backgroundImageView.image = lesson.backgroundImage
        if isLocked {
            playImageView.image = Assets.locked.image
        } else {
            playImageView.image = Assets.play.image
        }
    }

    func configure(with model: MainPageCellViewModel) {
        guard let lesson = model.data as? Lesson else { return }
        configure(with: lesson, isLocked: model.isLocked)
    }
}

// MARK: - ViewImageBasedAnimatable

extension LessonCell: ViewImageBasedAnimatable {
    public var mainView: UIView {
        return contentView
    }

    public override var imageView: UIImageView {
        return backgroundImageView
    }

    public var isImageDisappeared: Bool {
        return false
    }
}
