//
//  PersonalCategoriesDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

final class PersonalCategoriesDataSource: NSObject {
    // MARK: - Properties

    var data: [PersonalCategory] = []
    private var collectionView: UICollectionView
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Init

    init(
        data: [PersonalCategory]? = nil,
        collectionView: UICollectionView
    ) {
        self.collectionView = collectionView
        self.data = data ?? []
        super.init()
        collectionView.register(
            PersonalCategoryCell.self,
            forCellWithReuseIdentifier: PersonalCategoryCell.identifier
        )
        collectionView.register(
            PersonalizationTitleView.nib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PersonalizationTitleView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Internal methods

    func updatedata(_ data: [PersonalCategory]) {
        self.data = data
        collectionView.reloadData()
    }

    func getSelecteddata() -> [PersonalCategory] {
        var selecteddata: [PersonalCategory] = []
        for index in data.indices {
            for item in collectionView.indexPathsForSelectedItems ?? []
                where item.row == index {
                selecteddata.append(data[index])
            }
        }
        return selecteddata
    }
}

// MARK: - UICollectionViewDataSource

extension PersonalCategoriesDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PersonalCategoryCell.identifier,
            for: indexPath
        ) as? PersonalCategoryCell else {
            return PersonalCategoryCell()
        }
        let item = data[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: PersonalizationTitleView.identifier,
            for: indexPath
        ) as? PersonalizationTitleView
        return sectionHeader ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension PersonalCategoriesDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionFeedbackGenerator.selectionChanged()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectionFeedbackGenerator.selectionChanged()
    }
}
