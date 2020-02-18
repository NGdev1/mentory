//
//  LessonHeaderCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class LessonHeaderCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        selectionStyle = .none
    }

    // MARK: - Internal methods

    func configure(with lesson: Lesson) {
        titleLabel.text = lesson.title
        if lesson.tracks.count == 1 {
            subtitleLabel.text = Text.Lesson.subtitleOneTrack(lesson.subtitle)
        } else if lesson.tracks.count < 5 {
            subtitleLabel.text = Text.Lesson.subtitle2to4Tracks(lesson.subtitle, lesson.tracks.count)
        } else {
            subtitleLabel.text = Text.Lesson.subtitleFrom5Tracks(lesson.subtitle, lesson.tracks.count)
        }
        descriptionLabel.text = lesson.description
    }
}
