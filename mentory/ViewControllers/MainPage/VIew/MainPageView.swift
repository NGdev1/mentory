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
