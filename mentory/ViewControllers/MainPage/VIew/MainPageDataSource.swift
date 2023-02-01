//
//  MainPageDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import MDFoundation
import Storable
import UIKit

protocol MainPageDataSourceDelegate: AnyObject {
    func showPurchasePage()
    func showStory(_ story: Story, view: StoryCell?)
    func displayLesson(
        _ lesson: Lesson,
        lessonIsLocked: Bool,
        nextLesson: Lesson?,
        nextLessonIsLocked: Bool?,
        cellView: LessonCell?
    )
}

final class MainPageDataSource: NSObject {
    // MARK: - Properties

    private var data: [MainPageCellViewModel]?
    private var tableView: UITableView

    weak var delegate: MainPageDataSourceDelegate?

    // MARK: - Init

    init(data: [MainPageCellViewModel]? = nil, tableView: UITableView) {
        self.tableView = tableView
        self.data = data
        super.init()
        tableView.register(
            PersonalizedCell.nib, forCellReuseIdentifier: PersonalizedCell.identifier
        )
        tableView.register(
            TodayCell.nib, forCellReuseIdentifier: TodayCell.identifier
        )
        tableView.register(
            StoriesCell.self, forCellReuseIdentifier: StoriesCell.identifier
        )
        tableView.register(
            QuotesCell.self, forCellReuseIdentifier: QuotesCell.identifier
        )
        tableView.register(
            LessonCell.nib, forCellReuseIdentifier: LessonCell.identifier
        )
        tableView.register(
            SectionHeaderCell.nib, forCellReuseIdentifier: SectionHeaderCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Internal methods

    func updateData(_ data: [MainPageCellViewModel]) {
        self.data = data
        tableView.reloadData()
    }

    func getNextLesson(after lesson: Lesson) -> NextLessonRetrievingResult? {
        guard var row = data?.firstIndex(where: { model in
            model.type == .lesson &&
                (model.data as? Lesson)?.id == lesson.id
        }) else { return nil }
        let indexPath = IndexPath(row: row, section: 0)
        let view = tableView.cellForRow(at: indexPath) as? LessonCell
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        row += 1
        while row < (data?.count ?? 0) {
            let nextItem: MainPageCellViewModel? = data?[row]
            if nextItem?.type == .lesson {
                let nextLesson = nextItem?.data as? Lesson
                let nextLessonLocked = nextItem?.isLocked
                return NextLessonRetrievingResult(
                    lesson: nextLesson,
                    isLocked: nextLessonLocked,
                    cellView: view
                )
            }
            row += 1
        }
        return nil
    }

    func getNextStory(after story: Story) -> StoryRetrievingResult? {
        guard let row = data?.firstIndex(where: { model in
            model.type == .stories
        }) else { return nil }
        let indexPath = IndexPath(row: row, section: 0)
        let storiesCell = tableView.cellForRow(at: indexPath) as? StoriesCell
        return storiesCell?.getNextStory(after: story)
    }

    func getPreviousStory(before story: Story) -> StoryRetrievingResult? {
        guard let row = data?.firstIndex(where: { model in
            model.type == .stories
        }) else { return nil }
        let indexPath = IndexPath(row: row, section: 0)
        let storiesCell = tableView.cellForRow(at: indexPath) as? StoriesCell
        return storiesCell?.getPreviousStory(before: story)
    }
}

// MARK: - UITableViewDataSource

extension MainPageDataSource: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = data?[indexPath.row] else {
            return UITableViewCell()
        }
        switch item.type {
        case .sectionHeader:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SectionHeaderCell.identifier,
                for: indexPath
            ) as? SectionHeaderCell
            cell?.configure(with: item, delegate: self)
            return cell ?? UITableViewCell()
        case .lesson:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LessonCell.identifier,
                for: indexPath
            ) as? LessonCell
            cell?.configure(with: item)
            return cell ?? UITableViewCell()
        case .personalized:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PersonalizedCell.identifier,
                for: indexPath
            ) as? PersonalizedCell
            let name = AppService.shared.app.userName
            cell?.configure(name: name ?? .empty, delegate: self)
            return cell ?? UITableViewCell()
        case .stories:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: StoriesCell.identifier,
                for: indexPath
            ) as? StoriesCell
            cell?.configure(with: item, delegate: self)
            return cell ?? UITableViewCell()
        case .quotes:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: QuotesCell.identifier,
                for: indexPath
            ) as? QuotesCell
            cell?.configure(with: item, delegate: self)
            return cell ?? UITableViewCell()
        case .today:
            return tableView.dequeueReusableCell(
                withIdentifier: TodayCell.identifier,
                for: indexPath
            )
        }
    }
}

// MARK: - UITableViewDelegate

extension MainPageDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = data?[indexPath.row] else {
            return 165
        }

        switch item.type {
        case .sectionHeader, .personalized, .today, .stories, .quotes:
            return UITableView.automaticDimension
        case .lesson:
            return 165
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = data?[indexPath.row] else { return }
        if item.type == .lesson {
            let cell = tableView.cellForRow(at: indexPath) as? LessonCell
            guard let lesson = item.data as? Lesson else { return }
            var nextLesson: Lesson?
            var nextLessonLocked: Bool?
            var row = indexPath.row + 1
            while row < (data?.count ?? 0) {
                let nextItem: MainPageCellViewModel? = data?[row]
                if nextItem?.type == .lesson {
                    nextLesson = nextItem?.data as? Lesson
                    nextLessonLocked = nextItem?.isLocked
                    break
                }
                row += 1
            }
            delegate?.displayLesson(
                lesson, lessonIsLocked: item.isLocked,
                nextLesson: nextLesson, nextLessonIsLocked: nextLessonLocked,
                cellView: cell
            )
        }
    }
}

// MARK: - Cell actions

extension MainPageDataSource: PersonalizedCellDelegate, SectionHeaderCellDelegate,
    StoriesCellDelegate, QuotesCellDelegate
{
    func showStory(_ story: Story, view: StoryCell?) {
        delegate?.showStory(story, view: view)
    }
}
