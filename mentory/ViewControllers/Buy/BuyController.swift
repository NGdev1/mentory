//
//  BuyController.swift
//  mentory
//
//  Created by Михаил Андреичев on 26.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import StoreKit

protocol BuyControllerLogic: AnyObject {
    func purchaseCompleted()
    func didLoadProducts(_ products: [Product])
    func presentError(message: String)
}

public class BuyController: UIViewController, BuyControllerLogic {
    // MARK: - Properties

    var interactor: BuyInteractor?
    lazy var customView: BuyView? = view as? BuyView

    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Init

    public init() {
        super.init(
            nibName: Utils.getClassName(BuyView.self),
            bundle: Bundle(for: BuyView.self)
        )
        setup()
        addActionHandlers()
        loadProducts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        interactor = BuyInteractor()
        interactor?.controller = self
    }

    // MARK: - Network

    private func loadProducts() {
        interactor?.loadProducts()
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside
        )
        customView?.buyButton.addTarget(
            self,
            action: #selector(buy),
            for: .touchUpInside
        )
        customView?.restorePurchases.addTarget(
            self,
            action: #selector(restorePurchases),
            for: .touchUpInside
        )
        customView?.delegate = self
    }

    @objc func close() {
        dismiss(animated: true)
    }

    @objc func buy() {
        let product: IAPProduct = customView?.currentState == BuyView.State.buyPerMonth
            ? IAPProduct.monthly : IAPProduct.yearly
        interactor?.purchase(product: product)
    }

    @objc func restorePurchases() {
        interactor?.restorePurchases()
    }

    // MARK: - BuyControllerLogic

    func purchaseCompleted() {
        close()
    }

    func didLoadProducts(_ products: [Product]) {
        for product in products {
            if product.iapProduct == .yearly {
                customView?.setYearlyProduct(product: product.skProduct)
            } else {
                customView?.setMonthlyProduct(product: product.skProduct)
            }
        }
    }

    func presentError(message: String) {
        customView?.stopShowingActivityIndicator()
        guard message != .empty else { return }
        let alert = AlertsFactory.error(
            title: Text.Alert.error,
            message: message,
            cancelText: Text.Alert.cancel
        )
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - BuyViewDelegate

extension BuyController: BuyViewDelegate {
    func planChanged(state: BuyView.State) {
        selectionFeedbackGenerator.selectionChanged()
    }
}
