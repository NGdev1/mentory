//
//  PersonalCategoryCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

final class PersonalCategoryCell: UICollectionViewCell {
    // MARK: - Properties

    lazy var personalCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = Assets.background1.color
        imageView.kf.indicatorType = .activity
        imageView.image = Assets.david.image
        return imageView
    }()

    lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.borderColor = Assets.winterGreen.color
        imageView.image = Assets.gradient.image
        return imageView
    }()

    lazy var checkBox: MDCheckbox = {
        let checkBox = MDCheckbox()
        checkBox.bgColorSelected = .clear
        checkBox.line = .normal
        checkBox.borderColorSelected = Assets.winterGreen.color
        checkBox.color = Assets.winterGreen.color
        checkBox.borderWidth = 2
        checkBox.checkboxCornerRadius = 8
        checkBox.isUserInteractionEnabled = false
        checkBox.setOn(false)
        return checkBox
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = Assets.title.color
        label.font = Fonts.SFUIDisplay.bold.font(size: 16)
        label.numberOfLines = 0
        return label
    }()

    public lazy var tapRecognizer = UITapGestureRecognizer()

    var personalCategory: PersonalCategory?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupStyle() {
        contentView.layer.masksToBounds = false
    }

    private func addSubviews() {
        addSubview(personalCategoryImageView)
        addSubview(gradientImageView)
        addSubview(checkBox)
        addSubview(label)
    }

    private func makeConstraints() {
        personalCategoryImageView.makeEdgesEqualToSuperview()
        gradientImageView.makeEdgesEqualToSuperview()
        checkBox.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
        label.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(16)
        }
    }

    // MARK: - Internal methods

    func configure(with personalCategory: PersonalCategory) {
        self.personalCategory = personalCategory
        label.text = personalCategory.name
    }

    // MARK: - Overriden properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                gradientImageView.animateBorderWidth(toValue: 2)
                checkBox.setOn(true, animated: true)
            } else {
                gradientImageView.animateBorderWidth(toValue: 0)
                checkBox.setOn(false, animated: true)
            }
        }
    }
}
