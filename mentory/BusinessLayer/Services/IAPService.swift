//
//  IAPService.swift
//  mentory
//
//  Created by Михаил Андреичев on 02.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPServiceDelegate: AnyObject {
    func didLoadProducts(_ skProducts: [SKProduct])
}

final class IAPService: NSObject {
    // MARK: - Properties

    private var products: [SKProduct] = []
    private let paymentQueue = SKPaymentQueue.default()

    weak var delegate: IAPServiceDelegate?

    var isDataLoaded: Bool {
        products.isEmpty == false
    }

    // MARK: - Init

    private override init() {
        super.init()
        paymentQueue.add(self)
    }

    static let shared: IAPService = IAPService()

    // MARK: - Internal methods

    func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: [
            IAPProduct.yearly.rawValue,
            IAPProduct.monthly.rawValue,
        ])
        request.delegate = self
        request.start()
    }

    func purchase(product: IAPProduct) {
        guard let skProduct = products.first(where: { skProduct in
            skProduct.productIdentifier == product.rawValue
        }) else { return }
        let payment = SKPayment(product: skProduct)
        paymentQueue.add(payment)
    }

    func restore() {
        paymentQueue.restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        products = response.products
        delegate?.didLoadProducts(products)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        for transiction in transactions {
            if transiction.transactionState == .purchasing { continue }

            queue.finishTransaction(transiction)
        }
    }
}
