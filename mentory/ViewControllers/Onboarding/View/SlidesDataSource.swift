//
//  SlidesDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

protocol SlidesDataSourceDelegate: AnyObject {
    func pageChanged(page: Int)
}

final class SlidesDataSource: NSObject {
    // MARK: - Properties

    private var data: [Slide] = []
    private var collectionView: UICollectionView
    weak var delegate: SlidesDataSourceDelegate?
    var currentPage: Int = 0

    // MARK: - Init

    init(data: [Slide] = [], collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.data = data
        super.init()
        collectionView.register(
            SlideCell.nib,
            forCellWithReuseIdentifier: SlideCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Internal methods

    func nextPage() {
        guard currentPage < data.count - 1 else { return }
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func updateData(_ data: [Slide]) {
        self.data = data
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SlidesDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SlideCell.identifier,
            for: indexPath
        ) as? SlideCell
        let item = data[indexPath.row]
        cell?.configure(with: item)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension SlidesDataSource: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let halfOfScreen: CGFloat = UIScreen.main.bounds.width / 2
        let nextPagePosition: CGFloat = scrollView.contentOffset.x + halfOfScreen
        let currentIndex = Int(nextPagePosition / UIScreen.main.bounds.width)
        if currentIndex != currentPage {
            currentPage = currentIndex
            delegate?.pageChanged(page: currentIndex)
        }
    }
}
