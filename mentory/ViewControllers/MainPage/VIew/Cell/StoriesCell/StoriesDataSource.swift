//
//  StoriesDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 10.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

protocol StoriesDataSourceDelegate: AnyObject {
    func showStory(_ story: Story, view: StoryCell?)
}

final class StoriesDataSource: NSObject {
    // MARK: - Properties

    var data: [Story] = []
    private var collectionView: UICollectionView

    weak var delegate: StoriesDataSourceDelegate?

    // MARK: - Init

    init(
        data: [Story]? = nil,
        delegate: StoriesDataSourceDelegate,
        collectionView: UICollectionView
    ) {
        self.collectionView = collectionView
        self.data = data ?? []
        self.delegate = delegate
        super.init()
        collectionView.register(
            StoryCell.self,
            forCellWithReuseIdentifier: StoryCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Internal methods

    func updateStories(_ data: [Story]) {
        self.data = data
        collectionView.reloadData()
    }

    func getIndexOfStory(_ sotry: Story) -> Int? {
        return data.firstIndex(where: { dateStory in
            dateStory.id == sotry.id
        })
    }

    func getNextStory(after story: Story) -> StoryRetrievingResult? {
        guard var row = getIndexOfStory(story) else { return nil }
        let indexPath = IndexPath(row: row, section: 0)
        let view = collectionView.cellForItem(at: indexPath) as? StoryCell
        collectionView.scrollToItem(
            at: indexPath, at: .centeredHorizontally, animated: false
        )
        row += 1
        if row >= data.count {
            return nil
        } else {
            let nextStory: Story = data[row]
            return StoryRetrievingResult(story: nextStory, cellView: view)
        }
    }

    func getPreviousStory(before story: Story) -> StoryRetrievingResult? {
        guard var row = getIndexOfStory(story) else { return nil }
        let indexPath = IndexPath(row: row, section: 0)
        let view = collectionView.cellForItem(at: indexPath) as? StoryCell
        collectionView.scrollToItem(
            at: indexPath, at: .centeredHorizontally, animated: false
        )
        row -= 1
        if row < 0 {
            return nil
        } else {
            let previousStory: Story = data[row]
            return StoryRetrievingResult(story: previousStory, cellView: view)
        }
    }

    func getStoryCell(of index: Int) -> StoryCell? {
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? StoryCell
    }
}

// MARK: - UICollectionViewDataSource

extension StoriesDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCell.identifier,
            for: indexPath
        ) as? StoryCell
        let photo = data[indexPath.row]
        cell?.configure(with: photo)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension StoriesDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let view = collectionView.cellForItem(at: indexPath) as? StoryCell
        let photo = data[indexPath.row]
        delegate?.showStory(photo, view: view)
    }
}
