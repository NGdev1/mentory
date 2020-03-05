//
//  LessonCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Kingfisher
import UIKit

class LessonCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var viewWithInsets: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playImageView: UIImageView!

    @IBOutlet var tagView: UIView!
    @IBOutlet var tagLabel: UILabel!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        backgroundImageView.kf.indicatorType = .activity
        selectionStyle = .none
    }

    // MARK: - Internal methods

    func configure(with lesson: Lesson, isLocked: Bool) {
        titleLabel.text = lesson.title
        if lesson.tracks.count == 1 {
            subtitleLabel.text = Text.Lesson.subtitleOneTrack(lesson.subtitle)
        } else if lesson.tracks.count < 5 {
            subtitleLabel.text = Text.Lesson.subtitle2to4Tracks(lesson.subtitle, lesson.tracks.count)
        } else {
            subtitleLabel.text = Text.Lesson.subtitleFrom5Tracks(lesson.subtitle, lesson.tracks.count)
        }
        if let imageUrl = URL(string: lesson.backgroundImageUrl) {
            backgroundImageView.kf.setImage(with: imageUrl)
        }
        if isLocked {
            playImageView.image = Assets.locked.image
        } else {
            playImageView.image = Assets.play.image
        }
        tagView.isHidden = lesson.tag == nil
        tagLabel.text = lesson.tag
    }

    func configure(with model: MainPageCellViewModel) {
        guard let lesson = model.data as? Lesson else { return }
        configure(with: lesson, isLocked: model.isLocked)
    }
}

// MARK: - ViewImageBasedAnimatable

extension LessonCell: ViewImageBasedAnimatable {
    var mainView: UIView {
        return viewWithInsets
    }

    public override var imageView: UIImageView {
        return backgroundImageView
    }

    public var isImageDisappeared: Bool {
        return false
    }
}
