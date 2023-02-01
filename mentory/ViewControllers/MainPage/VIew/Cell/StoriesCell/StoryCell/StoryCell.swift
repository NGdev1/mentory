//
//  StoryCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 10.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

final class StoryCell: UICollectionViewCell {
    // MARK: - Properties

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = false
        // imageView.backgroundColor = Assets.background2.color
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.image = Assets.gradient.image
        return imageView
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.background1.color
        view.cornerRadius = 12
        view.borderColor = Assets.winterGreen.color
        view.borderWidth = 2
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Assets.title.color
        label.font = Fonts.SFUIDisplay.medium.font(size: 14)
        label.contentMode = .bottom
        return label
    }()

    var story: Story?

    var storySelected: ((Story) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupStyle() {
        contentView.layer.masksToBounds = false
    }

    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(photoImageView)
        photoImageView.addSubview(gradientImageView)
        containerView.addSubview(titleLabel)
    }

    private func makeConstraints() {
        containerView.makeEdgesEqualToSuperview()
        photoImageView.makeEdgesEqualToSuperview(inset: UIEdgeInsets(uniform: 5))
        gradientImageView.makeEdgesEqualToSuperview()
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(8)
            make.top.greaterThanOrEqualToSuperview().inset(8)
        }
    }

    // MARK: - Internal methods

    func configure(with story: Story) {
        self.story = story
        titleLabel.text = story.text
        if let url = URL(string: story.imageUrl) {
            photoImageView.kf.setImage(with: url)
        }
        if story.isRead {
            containerView.borderColor = Assets.blackThree.color
        } else {
            containerView.borderColor = Assets.winterGreen.color
        }
    }
}

// MARK: - ViewImageBasedAnimatable

extension StoryCell: ViewImageBasedAnimatable {
    var imageView: UIImageView {
        photoImageView
    }
}
