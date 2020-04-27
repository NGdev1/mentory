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
        button.setTitle(Text.Name.next, for: .normal)
        return button
    }()

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        setupStyle()
        addSubviews()
        makeConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = Assets.background1.color
    }

    private func addSubviews() {
        addSubview(actionButton)
    }

    private func makeConstraints() {
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(15)
        }
    }
}
