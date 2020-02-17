//
//  MDHeaderView.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

public final class MDHeaderView: UIView {
    struct Appearance {}

    // MARK: - Properties

    private let appearance = Appearance()

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = Assets.black.color
        view.alpha = 0
        return view
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Assets.title.color
        label.font = Fonts.SFUIDisplay.bold.font(size: 17)
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubviews()
        makeConstraints()
        setupStyle()
    }

    private func setupStyle() {}

    private func addSubviews() {
        addSubview(imageView)
        addSubview(dimmingView)
        dimmingView.addSubview(titleLabel)
    }

    private func makeConstraints() {
        imageView.makeEdgesEqualToSuperview()
        dimmingView.makeEdgesEqualToSuperview()
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }

    // MARK: - Public methods

    public func setTitle(_ text: String?) {
        titleLabel.text = text
    }

    public func updateAlphaChangingByScroll(
        currentPoint: CGFloat,
        startTurningWhitePoint: CGFloat,
        turnСompletelyWhitePoint: CGFloat
    ) {
        if currentPoint < startTurningWhitePoint {
            dimmingView.alpha = 0
        } else if currentPoint >= startTurningWhitePoint, currentPoint < turnСompletelyWhitePoint {
            let turningDelta = turnСompletelyWhitePoint - startTurningWhitePoint
            dimmingView.alpha = (currentPoint - startTurningWhitePoint) / turningDelta
        } else {
            dimmingView.alpha = 1
        }
    }

    public func updateContent(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url)
    }
}
