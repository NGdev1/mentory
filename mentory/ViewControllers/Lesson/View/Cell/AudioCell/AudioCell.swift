//
//  AudioCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Storable
import UIKit

class AudioCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var playImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        selectionStyle = .none
    }

    // MARK: - Internal methods

    func configure(with track: Track) {
        if track.isLocked, AppService.shared.app.appState == .free {
            playImageView.image = Assets.locked.image
        } else {
            playImageView.image = Assets.play.image
        }
        titleLabel.text = track.title
        subtitleLabel.text = track.subtitle
    }
}
