//
//  IAPService.swift
//  mentory
//
//  Created by Михаил Андреичев on 02.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import Moya
import Storable
import StoreKit

protocol IAPServiceDelegate: AnyObject {
    func didFailPurchase()
    func didCompletePurchase()
    func didLoadProducts(_ skProducts: [SKProduct])
}

final class IAPService: NSObject {
    // MARK: - Properties

    private var products: [SKProduct] = []
    private let paymentQueue = SKPaymentQueue.default()
    private var request: SKProductsRequest?
    let dataProvider = MoyaProvider<ItunesApi>()

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
        request?.cancel()
        request = SKProductsRequest(productIdentifiers: [
            IAPProduct.yearly.rawValue,
            IAPProduct.monthly.rawValue,
        ])
        request?.delegate = self
        request?.start()
    }

    func checkSubscription() {
        guard
            let url = Bundle.main.appStoreReceiptURL,
            let receiptData = try? Data(contentsOf: url, options: .alwaysMapped)
        else { return }
        let receiptString = receiptData.base64EncodedString(options: [])
        let request = VerifyReceiptRequest(
            recieptData: receiptString,
            password: "d0f8706027ea4c05a2c5b42f64da0293"
        )

        dataProvider.request(.verifyReceipt(request)) { result in
            switch result {
            case let .success(moyaResponse):
                guard moyaResponse.statusCode == 200
                else { return }
                let decoder = JSONDecoder()
                let response = try? decoder.decode(
                    VerifyReceiptResponse.self,
                    from: moyaResponse.data
                )
                if let expiresDate = response?.lastReciepts.last?.expiresDate {
                    print("Date subscription will expired: \(expiresDate)")
                    if expiresDate < Date() {
                        AppService.shared.app.appState = .free
                        NotificationCenter.default.post(Notification(name: .appStateChanged))
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
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
        delegate?.didFailPurchase()
        print(error.localizedDescription)
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing, .deferred:
                continue
            case .purchased, .restored:
                delegate?.didCompletePurchase()
                AppService.shared.app.appState = .premium
                NotificationCenter.default.post(Notification(name: .appStateChanged))
            case .failed:
                delegate?.didFailPurchase()
            @unknown default:
                break
            }

            if transaction.transactionState != .purchasing, transaction.transactionState != .deferred {
                queue.finishTransaction(transaction)
            }
        }
    }
}
