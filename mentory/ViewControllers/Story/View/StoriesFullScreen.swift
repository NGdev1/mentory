//
//  StoriesFullScreen.swift
//  mentory
//
//  Created by Михаил Андреичев on 21.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation

final class StoriesFullScreen: UIView {
    // MARK: - Properties

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var progressStackView: UIStackView!
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        setupStyle()
    }

    private func setupStyle() {
        frame = UIScreen.main.bounds
        titleLabel.text = .empty
    }

    // MARK: - Internal methods

    func displayStory(story: Story) {
        titleLabel.text = story.text
        if let url = URL(string: story.imageUrl) {
            storyImageView.kf.setImage(with: url)
            backgroundImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - ViewImageBasedAnimatable

extension StoriesFullScreen: ViewImageBasedAnimatable {
    var imageView: UIImageView {
        return storyImageView
    }
}
