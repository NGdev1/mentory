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
        static var bottomViewHeight: CGFloat {
            if AppService.shared.app.appState == .premium {
                return 0
            } else {
                return 80
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
        tableView.backgroundColor = Assets.black.color
        tableView.contentInset = UIEdgeInsets(top: 23, left: 0, bottom: 23, right: 0)
        return tableView
    }()

    lazy var headerView: UIView = {
        var view = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        ))
        let imageView = UIImageView(image: Assets.titleImage.image)
        imageView.frame = CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        return view
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
        backgroundColor = Assets.black.color
    }

    private func addSubviews() {
        addSubview(tableView)
        tableView.tableHeaderView = headerView
        addSubview(tryPremiumView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(tryPremiumView.snp.top)
        }
        tryPremiumView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Appearance.bottomViewHeight)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    // MARK: - Internal methods

    func hideBottomView() {
        tryPremiumView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
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
