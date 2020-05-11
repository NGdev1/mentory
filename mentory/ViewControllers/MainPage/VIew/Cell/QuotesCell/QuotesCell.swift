//
//  QuotesCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

protocol QuotesCellDelegate: AnyObject {}

final class QuotesCell: UITableViewCell {
    struct Appearance {
        static let cellSize = CGSize(UIScreen.main.bounds.width - 47)
    }

    // MARK: - Properties

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Appearance.cellSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: frame,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = Assets.background1.color
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    lazy var dataSource: QuotesDataSource = QuotesDataSource(
        delegate: self, collectionView: collectionView
    )

    weak var delegate: QuotesCellDelegate?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    private func setupStyle() {
        backgroundColor = Assets.background1.color
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
    }

    private func addSubviews() {
        addSubview(collectionView)
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Appearance.cellSize.height)
        }
    }

    // MARK: - Internal methods

    func configure(
        with model: MainPageCellViewModel,
        delegate: QuotesCellDelegate
    ) {
        self.delegate = delegate
        if let data = model.data as? [Quote] {
            dataSource.updateQuotes(data)
        }
    }
}

// MARK: - QuotesDataSourceDelegate

extension QuotesCell: QuotesDataSourceDelegate {
    func showQuote(_ quote: Quote, view: QuoteCell?) {}
}
