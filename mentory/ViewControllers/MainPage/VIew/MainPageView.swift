//
//  MainPageView.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import MDFoundation
import UIKit

final class MainPageView: UIView {
    // MARK: - Properties

    var dataSource: MainPageDataSource?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.keyboardDismissMode = .interactive
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 23, left: 0, bottom: 23, right: 0)
        return tableView
    }()

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

    private func setupStyle() {}

    private func addSubviews() {
        addSubview(tableView)
    }

    private func makeConstraints() {
        tableView.makeEdgesEqualToSuperview()
    }

    // MARK: - Internal methods

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
