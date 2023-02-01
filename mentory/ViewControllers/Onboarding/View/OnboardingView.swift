//
//  OnboardingView.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    enum Appearance {
        static let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.5 - 20
        static let bigButtonWidth: CGFloat = UIScreen.main.bounds.width - 32
        static let buttonsDistance: CGFloat = 8
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var nextButtonWidth: NSLayoutConstraint!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var skipButtonWidth: NSLayoutConstraint!
    @IBOutlet var buttonsDistance: NSLayoutConstraint!

    lazy var dataSource: SlidesDataSource = .init(collectionView: collectionView)

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        setupStyle()
    }

    private func setupStyle() {
        logoImageView.isHidden = ScreenSize.current == .sizeIPhoneSE
        backgroundColor = Assets.background1.color
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.allowsSelection = false
        nextButton.setTitle(Text.Onboarding.next, for: .normal)
        skipButton.setTitle(Text.Onboarding.skip, for: .normal)
        nextButtonWidth.constant = Appearance.buttonWidth
        skipButtonWidth.constant = Appearance.buttonWidth
        buttonsDistance.constant = Appearance.buttonsDistance
    }

    // MARK: - Private methods

    func setLastPageAppearance() {
        nextButton.setTitle(Text.Onboarding.begin, for: .normal)
        skipButton.fadeOut()
        skipButtonWidth.constant = 0
        buttonsDistance.constant = 0
        nextButtonWidth.constant = Appearance.bigButtonWidth
        UIView.animate(withDuration: Appearance.animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    func setCommonPageAppearance() {
        nextButton.setTitle(Text.Onboarding.next, for: .normal)
        skipButton.fadeIn()
        nextButtonWidth.constant = Appearance.buttonWidth
        skipButtonWidth.constant = Appearance.buttonWidth
        buttonsDistance.constant = Appearance.buttonsDistance
        UIView.animate(withDuration: Appearance.animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    // MARK: - Internal methods

    func getPage() -> Int {
        return dataSource.currentPage
    }

    func setDelegate(_ delegate: SlidesDataSourceDelegate) {
        dataSource.delegate = delegate
    }

    func updateData(data: [Slide]) {
        dataSource.updateData(data)
        pageControl.numberOfPages = data.count
    }

    func nextPage() {
        dataSource.nextPage()
    }

    func pageChanged(index: Int, pagesCount: Int) {
        pageControl.currentPage = index
        if index == pagesCount - 1 {
            setLastPageAppearance()
        } else {
            setCommonPageAppearance()
        }
    }
}
