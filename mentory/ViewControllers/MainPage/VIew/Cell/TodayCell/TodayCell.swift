//
//  TodayCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 19.02.2020.
//

import UIKit

final class TodayCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var yourPlanLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Text.Today.dateFormat
        return dateFormatter
    }()

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
        yourPlanLabel.text = Text.Today.yourPlan
        fromLabel.text = Text.Today.from
        dateLabel.text = dateFormatter.string(from: Date()).uppercased()
    }
}
