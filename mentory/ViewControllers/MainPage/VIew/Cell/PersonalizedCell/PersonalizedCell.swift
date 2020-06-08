//
//  PersonalizedCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 19.02.2020.
//

import UIKit

protocol PersonalizedCellDelegate: AnyObject {}

final class PersonalizedCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

    weak var delegate: PersonalizedCellDelegate?

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        addActionHandlers()
    }

    private func setupStyle() {
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: Date())
        if hours < 6 {
            greetingLabel.text = Text.Personalized.goodNight
        } else if hours < 12 {
            greetingLabel.text = Text.Personalized.goodMorning
        } else if hours < 18 {
            greetingLabel.text = Text.Personalized.goodAfternoon
        } else {
            greetingLabel.text = Text.Personalized.goodEvening
        }
    }

    // MARK: - Action handlers

    private func addActionHandlers() {}

    // MARK: - Public methods

    func configure(
        name: String,
        delegate: PersonalizedCellDelegate
    ) {
        nameLabel.text = name
        self.delegate = delegate
    }
}
