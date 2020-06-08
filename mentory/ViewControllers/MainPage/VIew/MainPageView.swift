//
//  MainPageView.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import MDFoundation
import Storable
import UIKit

final class MainPageView: UIView {
    struct Appearance {
        static var buttonPurchaseHeight: CGFloat {
            if AppService.shared.app.appState == .premium {
                return 0
            } else {
                return 60
            }
        }

        static var bottomInset: CGFloat {
            if AppService.shared.app.appState == .premium {
                return 23
            } else {
                return 97
            }
        }
    }

    // MARK: - Properties

    var dataSource: MainPageDataSource?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Assets.background1.color
        tableView.contentInset = UIEdgeInsets(
            top: 0, left: 0,
            bottom: Appearance.bottomInset, right: 0
        )
        return tableView
    }()

    lazy var tryPremiumView: TryPremiumView = XibInitializer.loadFromXib(type: TryPremiumView.self)

    // MARK: - Init

    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
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
    }

    private func addSubviews() {
        addSubview(tableView)
        addSubview(tryPremiumView)
    }

    private func makeConstraints() {
        tableView.makeEdgesEqualToSuperview()
        tryPremiumView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Appearance.buttonPurchaseHeight)
        }
    }

    // MARK: - Internal methods

    func hideBottomView() {
        tryPremiumView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        tableView.contentInset.bottom = 23
    }

    func initDataSource() {
        dataSource = MainPageDataSource(tableView: tableView)
    }

    func updateAppearance(with entity: [MainPageCellViewModel]) {
        dataSource?.updateData(entity)
    }

    func showEmptyPage() {
        dataSource?.updateData([])
    }
}
