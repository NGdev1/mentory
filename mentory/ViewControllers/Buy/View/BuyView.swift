//
//  BuyView.swift
//  mentory
//
//  Created by Михаил Андреичев on 26.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import StoreKit

protocol BuyViewDelegate: AnyObject {
    func planChanged(state: BuyView.State)
}

final class BuyView: UIView {
    enum State {
        case buyPerYear
        case buyPerMonth
    }

    // MARK: - Properties

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var tryFreeLabel: UILabel!

    @IBOutlet var adv1Label: UILabel!
    @IBOutlet var adv2Label: UILabel!
    @IBOutlet var adv3Label: UILabel!
    @IBOutlet var adv4Label: UILabel!
    @IBOutlet var adv5Label: UILabel!

    @IBOutlet var buyPerYearView: UIView!
    @IBOutlet var perYearTitle: UILabel!
    @IBOutlet var perYearSubtitle: UILabel!
    @IBOutlet var buyPerMonthView: UIView!
    @IBOutlet var perMonthTitle: UILabel!
    @IBOutlet var perMonthSubtitle: UILabel!

    weak var delegate: BuyViewDelegate?

    var currentState: State = .buyPerYear {
        didSet {
            switch currentState {
            case .buyPerYear:
                perYear()
            case .buyPerMonth:
                perMonth()
            }
            delegate?.planChanged(state: currentState)
        }
    }

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        setupStyle()
        addActionHandlers()
    }

    private func setupStyle() {
        tryFreeLabel.text = Text.Buy.tryFree

        adv1Label.text = Text.Buy.advantage1
        adv2Label.text = Text.Buy.advantage2
        adv3Label.text = Text.Buy.advantage3
        adv4Label.text = Text.Buy.advantage4
        adv5Label.text = Text.Buy.advantage5

        perYearTitle.text = Text.Buy.YearView.title
        perMonthTitle.text = Text.Buy.MonthView.title
        perYearSubtitle.text = Text.Buy.YearView.subtitle
        perMonthSubtitle.text = Text.Buy.MonthView.subtitle

        currentState = .buyPerYear
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        let perYearGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        buyPerYearView.addGestureRecognizer(perYearGesture)
        buyPerYearView.isUserInteractionEnabled = true
        let perMonthGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        buyPerMonthView.addGestureRecognizer(perMonthGesture)
        buyPerMonthView.isUserInteractionEnabled = true
    }

    @objc func handleGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.view == buyPerYearView {
            currentState = .buyPerYear
        } else {
            currentState = .buyPerMonth
        }
    }

    // MARK: - Internal methods

    func setYearlyProduct(product: SKProduct) {
        let currencySymbol: String = product.priceLocale.currencySymbol ?? .empty
        perYearTitle.text = Text.Buy.YearView.titleWithPrice("\(Int(truncating: product.price) / 12) \(currencySymbol)")
        perYearSubtitle.text = Text.Buy.YearView.subtitleWithPrice("\(Int(truncating: product.price)) \(currencySymbol)")
    }

    func setMonthlyProduct(product: SKProduct) {
        let currencySymbol: String = product.priceLocale.currencySymbol ?? .empty
        perMonthTitle.text = Text.Buy.MonthView.titleWithPrice("\(Int(truncating: product.price)) \(currencySymbol)")
        perMonthSubtitle.text = Text.Buy.MonthView.subtitleWithPrice("\(Int(truncating: product.price)) \(currencySymbol)")
    }

    // MARK: - Private methods

    private func perYear() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.perYearTitle.textColor = Assets.black.color
            self?.perMonthTitle.textColor = Assets.title.color
            self?.perYearSubtitle.textColor = Assets.black.color.withAlphaComponent(0.6)
            self?.perMonthSubtitle.textColor = Assets.warmGrey.color
            self?.buyPerYearView.backgroundColor = Assets.winterGreen.color
            self?.buyPerMonthView.backgroundColor = Assets.black.color
        }
    }

    private func perMonth() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.perYearTitle.textColor = Assets.title.color
            self?.perMonthTitle.textColor = Assets.black.color
            self?.perYearSubtitle.textColor = Assets.warmGrey.color
            self?.perMonthSubtitle.textColor = Assets.black.color.withAlphaComponent(0.6)
            self?.buyPerYearView.backgroundColor = Assets.black.color
            self?.buyPerMonthView.backgroundColor = Assets.winterGreen.color
        }
    }
}
