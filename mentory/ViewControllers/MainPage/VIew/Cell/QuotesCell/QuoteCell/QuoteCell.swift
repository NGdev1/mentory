//
//  QuoteCell.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

class QuoteCell: UICollectionViewCell {
    // MARK: - Properties

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!

    // MARK: - Xib init

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Internal methods

    func configure(with quote: Quote) {
        quoteLabel.text = quote.text
        authorNameLabel.text = quote.authorName
        if let url = URL(string: quote.imageUrl) {
            photoImageView.kf.setImage(with: url)
        }
    }
}
