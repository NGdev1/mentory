//
//  PersonalCategoriesView.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import UIKit

final class PersonalCategoriesView: UIView {
    struct Appearance {
        static let cellSize: CGSize = CGSize(
            width: (UIScreen.main.bounds.width / 2) - 20,
            height: ScreenSize.current == .sizeIPhoneSE ? 150 : 100
        )
    }

    // MARK: - Properties

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Appearance.cellSize
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: frame,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = Assets.background1.color
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.masksToBounds = true
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.contentInset.bottom = 100
        return collectionView
    }()

    lazy var nextView = NextInputView()

    var dataSource: PersonalCategoriesDataSource?

    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupStyle()
        addSubviews()
        makeConstraints()
        initDataSource()
    }

    private func initDataSource() {
        dataSource = PersonalCategoriesDataSource(
            collectionView: collectionView
        )
    }

    private func setupStyle() {
        backgroundColor = Assets.background1.color
    }

    private func addSubviews() {
        addSubview(collectionView)
        addSubview(nextView)
    }

    private func makeConstraints() {
        collectionView.makeEdgesEqualToSuperview()
        nextView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }

    // MARK: - Internal methods

    func updateData(_ data: [PersonalCategory]) {
        dataSource?.updatedata(data)
    }
}
