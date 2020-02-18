//
//  LessonViewDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import MDFoundation
import UIKit

protocol LessonViewDataSourceDelegate: AnyObject {
    func nextLesson()
    func playTrack(with index: Int)
    func didScroll(offset: CGFloat)
}

final class LessonViewDataSource: NSObject {
    // MARK: - Properties

    private var lesson: Lesson
    private var nextLesson: Lesson?
    private var nextLessonIsLocked: Bool
    private var tableView: UITableView
    private let notificationsFeedbackGenerator = UINotificationFeedbackGenerator()

    weak var delegate: LessonViewDataSourceDelegate?

    // MARK: - Init

    init(
        lesson: Lesson,
        nextLesson: Lesson?,
        nextLessonIsLocked: Bool,
        tableView: UITableView
    ) {
        self.tableView = tableView
        self.lesson = lesson
        self.nextLessonIsLocked = nextLessonIsLocked
        self.nextLesson = nextLesson
        super.init()
        tableView.register(LessonHeaderCell.nib, forCellReuseIdentifier: LessonHeaderCell.identifier)
        tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        tableView.register(NextLessonCell.nib, forCellReuseIdentifier: NextLessonCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Internal methods

    func updateData(
        lesson: Lesson,
        nextLesson: Lesson?,
        nextLessonIsLocked: Bool
    ) {
        self.lesson = lesson
        self.nextLesson = nextLesson
        self.nextLessonIsLocked = nextLessonIsLocked
        tableView.reloadData()
    }

    func getNextTrack(after track: Track) -> Track? {
        return lesson.tracks.first(where: { model in
            model.id == track.id
        })
    }
}

// MARK: - UITableViewDataSource

extension LessonViewDataSource: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if nextLesson == nil {
            return lesson.tracks.count + 1
        } else {
            return lesson.tracks.count + 2
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = cell as? LessonHeaderCell
            cell?.configure(with: lesson)
        } else if indexPath.row == lesson.tracks.count + 1 {
            let cell = cell as? NextLessonCell
            cell?.configure(with: nextLesson, isLocked: nextLessonIsLocked)
        } else {
            let cell = cell as? AudioCell
            let item = lesson.tracks[indexPath.row - 1]
            cell?.configure(with: item)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: LessonHeaderCell.identifier,
                for: indexPath
            )
        } else if indexPath.row == lesson.tracks.count + 1 {
            return tableView.dequeueReusableCell(
                withIdentifier: NextLessonCell.identifier,
                for: indexPath
            )
        } else {
            return tableView.dequeueReusableCell(
                withIdentifier: AudioCell.identifier,
                for: indexPath
            )
        }
    }
}

// MARK: - UITableViewDelegate

extension LessonViewDataSource: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == lesson.tracks.count + 1 {
            guard nextLessonIsLocked == false else {
                notificationsFeedbackGenerator.notificationOccurred(.error)
                let nextLessonCell = tableView.cellForRow(at: indexPath) as? NextLessonCell
                nextLessonCell?.nextLessonCell?.playImageView.shake()
                return
            }
            delegate?.nextLesson()
        } else if indexPath.row != 0 {
            delegate?.playTrack(with: indexPath.row - 1)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(offset: scrollView.contentOffset.y)
    }
}
