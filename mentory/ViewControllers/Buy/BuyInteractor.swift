//
//  BuyInteractor.swift
//  mentory
//
//  Created by Михаил Андреичев on 26.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import StoreKit

protocol BuyBusinessLogic: AnyObject {
    func loadProducts()
    func purchase(product: IAPProduct)
}

class BuyInteractor: BuyBusinessLogic, IAPServiceDelegate {
    // MARK: - Properties

    weak var controller: BuyControllerLogic?
    var service: IAPService = IAPService.shared

    // MARK: - Init

    init() {
        service.delegate = self
    }

    // MARK: - Init

    func purchase(product: IAPProduct) {
        service.purchase(product: product)
    }

    func loadProducts() {
        service.loadProducts()
    }

    // MARK: - Results

    func didFailPurchase() {
        controller?.presentError(message: Text.Buy.purchaseFailed)
    }

    func didCompletePurchase() {
        controller?.purchaseCompleted()
    }

    func didLoadProducts(_ skProducts: [SKProduct]) {
        var products: [Product] = []
        for skProduct in skProducts {
            guard let iapProduct = IAPProduct(rawValue: skProduct.productIdentifier)
            else { continue }
            products.append(Product(iapProduct: iapProduct, skProduct: skProduct))
        }
        DispatchQueue.main.async { [weak self] in
            self?.controller?.didLoadProducts(products)
        }
    }
}
