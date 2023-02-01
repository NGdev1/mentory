//
//  NextInputView.swift
//  mentory
//
//  Created by Михаил Андреичев on 27.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

public final class NextInputView: UIView {
    // MARK: - Properties

    public lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addShadow()
        button.backgroundColor = Assets.winterGreen.color
        button.cornerRadius = 10
        button.titleLabel?.font = Fonts.SFUIDisplay.bold.font(size: 14)
        button.setTitleColor(Assets.black.color, for: .normal)
        button.setTitle(Text.Name.next, for: .normal)
        return button
    }()

    // MARK: - Init

    public init() {
        super.init(
            frame: CGRect(
                x: 0, y: 0,
                width: UIScreen.main.bounds.width, height: 90
            )
        )
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .clear
    }

    private func addSubviews() {
        addSubview(actionButton)
    }

    private func makeConstraints() {
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
