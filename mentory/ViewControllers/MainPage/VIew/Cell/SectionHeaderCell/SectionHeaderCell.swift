//
//  SectionHeaderCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 19.02.2020.
//

import UIKit

protocol SectionHeaderCellDelegate: AnyObject {}

final class SectionHeaderCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var headerLabel: UILabel!
    weak var delegate: SectionHeaderCellDelegate?

    // MARK: - Xib init

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        addActionHandlers()
    }

    private func setupStyle() {
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
    }

    // MARK: - Action handlers

    private func addActionHandlers() {}

    // MARK: - Internal methods

    func configure(
        with model: MainPageCellViewModel,
        delegate: SectionHeaderCellDelegate
    ) {
        let viewModel = model.data as? MainPageSectionHeader
        headerLabel.text = viewModel?.title
        self.delegate = delegate
    }
}
