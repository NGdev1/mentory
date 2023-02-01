//
//  StoriesCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 19.02.2020.
//

import UIKit

protocol StoriesCellDelegate: AnyObject {
    func showStory(_ story: Story, view: StoryCell?)
}

final class StoriesCell: UITableViewCell {
    enum Appearance {
        static let cellSize = CGSize(96)
        static let height: CGFloat = 96
    }

    // MARK: - Properties

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Appearance.cellSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
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

    lazy var dataSource: StoriesDataSource = .init(
        delegate: self, collectionView: collectionView
    )

    weak var delegate: StoriesCellDelegate?

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
            make.height.equalTo(Appearance.height)
        }
    }

    // MARK: - Internal methods

    func configure(
        with model: MainPageCellViewModel,
        delegate: StoriesCellDelegate
    ) {
        self.delegate = delegate
        if let data = model.data as? [Story] {
            dataSource.updateStories(data)
        }
    }

    func getNextStory(after story: Story) -> StoryRetrievingResult? {
        return dataSource.getNextStory(after: story)
    }

    func getPreviousStory(before story: Story) -> StoryRetrievingResult? {
        return dataSource.getPreviousStory(before: story)
    }
}

// MARK: - StoriesDataSourceDelegate

extension StoriesCell: StoriesDataSourceDelegate {
    func showStory(_ story: Story, view: StoryCell?) {
        delegate?.showStory(story, view: view)
    }
}
