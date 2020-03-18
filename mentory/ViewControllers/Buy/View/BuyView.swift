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

    @IBOutlet var restorePurchases: UIButton!
    @IBOutlet var infoTextView: UITextView!
    @IBOutlet var buyInfoLabel: UILabel!
    @IBOutlet var buyButton: UIButton!

    weak var delegate: BuyViewDelegate?

    var yearlyPrice: String?
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
        tryFreeLabel.text = Text.Buy.subtitle

        adv1Label.text = Text.Buy.advantage1
        adv2Label.text = Text.Buy.advantage2
        adv3Label.text = Text.Buy.advantage3
        adv4Label.text = Text.Buy.advantage4
        adv5Label.text = Text.Buy.advantage5

        perYearTitle.text = Text.Buy.YearView.title
        perMonthTitle.text = Text.Buy.MonthView.title
        perYearSubtitle.text = Text.Buy.YearView.subtitle
        perMonthSubtitle.text = Text.Buy.MonthView.subtitle

        buyInfoLabel.text = .empty
        buyButton.setTitle(Text.Buy.get, for: .normal)
        infoTextView.attributedText = createAttributedString(
            regularString: Text.Buy.info,
            linkString: Text.Buy.privacyPolicy,
            urlString: "https://mentory.flycricket.io/privacy.html"
        )
        infoTextView.tintColor = Assets.title.color
        restorePurchases.setTitle(Text.Buy.restorePurchases, for: .normal)

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
        let price = Float(truncating: product.price)
        perYearTitle.text = Text.Buy.YearView.titleWithPrice(
            "\(price.currencyValue) \(currencySymbol)",
            "\((price / 12).currencyValue) \(currencySymbol)"
        )
        yearlyPrice = "\(price.currencyValue) \(currencySymbol)"
        if currentState == .buyPerYear {
            buyInfoLabel.text = Text.Buy.yearlyPrice("\(price.currencyValue) \(currencySymbol)")
        } else {
            buyInfoLabel.text = .empty
        }
    }

    func setMonthlyProduct(product: SKProduct) {
        let currencySymbol: String = product.priceLocale.currencySymbol ?? .empty
        let price = Float(truncating: product.price)
        perMonthTitle.text = Text.Buy.MonthView.titleWithPrice("\(price.currencyValue) \(currencySymbol)")
        buyInfoLabel.text = .empty
    }

    // MARK: - Private methods

    private func perYear() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.perYearTitle.textColor = Assets.background1.color
            self?.perMonthTitle.textColor = Assets.title.color
            self?.perYearSubtitle.textColor = Assets.background1.color.withAlphaComponent(0.6)
            self?.perMonthSubtitle.textColor = Assets.warmGrey.color
            self?.buyPerYearView.backgroundColor = Assets.winterGreen.color
            self?.buyPerMonthView.backgroundColor = Assets.background1.color
            self?.buyButton.setTitle(Text.Buy.get3DaysFree, for: .normal)
            if let yearlyPrice = self?.yearlyPrice {
                self?.buyInfoLabel.text = Text.Buy.yearlyPrice(yearlyPrice)
            } else {
                self?.buyInfoLabel.text = .empty
            }
        }
    }

    private func perMonth() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.perYearTitle.textColor = Assets.title.color
            self?.perMonthTitle.textColor = Assets.background1.color
            self?.perYearSubtitle.textColor = Assets.warmGrey.color
            self?.perMonthSubtitle.textColor = Assets.background1.color.withAlphaComponent(0.6)
            self?.buyPerYearView.backgroundColor = Assets.background1.color
            self?.buyPerMonthView.backgroundColor = Assets.winterGreen.color
            self?.buyButton.setTitle(Text.Buy.get, for: .normal)
            self?.buyInfoLabel.text = .empty
        }
    }

    private func createAttributedString(
        regularString: String,
        linkString: String,
        urlString: String
    ) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: "\(regularString)\(linkString)")

        let regularTextRange = NSRange(location: 0, length: regularString.count)
        let linkTextRange = NSRange(location: regularString.count, length: linkString.count)
        let allTextRange = NSRange(location: 0, length: text.string.count)
        guard
            let regularFont = Fonts.SFUIDisplay.regular.font(size: 12),
            let linkFont = Fonts.SFUIDisplay.bold.font(size: 12),
            let url = URL(string: urlString)
        else { return text }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3

        text.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: allTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.link,
            value: url,
            range: linkTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: Assets.coolGrey.color,
            range: regularTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: Assets.title.color,
            range: linkTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.font,
            value: regularFont,
            range: regularTextRange
        )
        text.addAttribute(
            NSAttributedString.Key.font,
            value: linkFont,
            range: linkTextRange
        )
        return text
    }
}
