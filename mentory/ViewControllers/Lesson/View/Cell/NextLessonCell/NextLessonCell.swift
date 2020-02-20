//
//  NextLessonCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

class NextLessonCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var nextLessonLabel: UILabel!
    @IBOutlet var nextLessonCellView: UIView!
    var nextLessonCell: LessonCell?

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        selectionStyle = .none
        nextLessonLabel.text = Text.Lesson.nextLesson
        nextLessonCell = XibInitializer.loadFromXib(type: LessonCell.self)
        if let view = nextLessonCell?.contentView {
            nextLessonCellView.addSubview(view)
            view.makeEdgesEqualToSuperview()
        }
    }

    // MARK: - Internal methods

    func configure(with lesson: Lesson?, isLocked: Bool) {
        guard let lesson = lesson else { return }
        nextLessonCell?.configure(with: lesson, isLocked: isLocked)
    }
}
