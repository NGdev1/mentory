//
//  QuotesDataSource.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

protocol QuotesDataSourceDelegate: AnyObject {
    func showQuote(_ quote: Quote, view: QuoteCell?)
}

final class QuotesDataSource: NSObject {
    // MARK: - Properties

    var data: [Quote] = []
    private var collectionView: UICollectionView

    weak var delegate: QuotesDataSourceDelegate?

    // MARK: - Init

    init(
        data: [Quote]? = nil,
        delegate: QuotesDataSourceDelegate,
        collectionView: UICollectionView
    ) {
        self.collectionView = collectionView
        self.data = data ?? []
        self.delegate = delegate
        super.init()
        collectionView.register(
            QuoteCell.nib,
            forCellWithReuseIdentifier: QuoteCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Internal methods

    func updateQuotes(_ data: [Quote]) {
        self.data = data
        collectionView.reloadData()
    }

    func getIndexOfQuote(_ sotry: Quote) -> Int? {
        return data.firstIndex(where: { dateQuote in
            dateQuote.id == sotry.id
        })
    }

    func getQuoteCell(of index: Int) -> QuoteCell? {
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? QuoteCell
    }
}

// MARK: - UICollectionViewDataSource

extension QuotesDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuoteCell.identifier,
            for: indexPath
        ) as? QuoteCell
        let photo = data[indexPath.row]
        cell?.configure(with: photo)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension QuotesDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let view = collectionView.cellForItem(at: indexPath) as? QuoteCell
        let photo = data[indexPath.row]
        delegate?.showQuote(photo, view: view)
    }
}
