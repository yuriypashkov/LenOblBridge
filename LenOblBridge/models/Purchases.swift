//
//  Purchases.swift
//  LenOblBridge
//
//  Created by Yuriy Pashkov on 2/25/21.
//  Copyright © 2021 Yuriy Pashkov. All rights reserved.
//

import Foundation
import StoreKit

class Purchases: NSObject {
    
    typealias RequestProductsResult = Result<[SKProduct], Error>
    typealias PurchaseProductResult = Result<Bool, Error>

    typealias RequestProductsCompletion = (RequestProductsResult) -> Void
    typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void
    

    
    static let `default` = Purchases()
    private let productIdentifiers = Set<String>(
        arrayLiteral: "lenOblBridgeAdCancel"
    )
    
    private var products: [String: SKProduct]?
    private var productRequest: SKProductsRequest?
    
    func initialize(completion: @escaping RequestProductsCompletion) {
        requestProducts(completion: completion)
    }
    
    private var productsRequestCallbacks = [RequestProductsCompletion]()
    
    private func requestProducts(completion: @escaping RequestProductsCompletion) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }

        productsRequestCallbacks.append(completion)

        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()

        self.productRequest = productRequest
    }
    
}

extension SKProduct {
    
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }

    var title: String? {
        switch productIdentifier {
        case "lenOblBridgeAdCancel":
            return "Отключить рекламу"
        default:
            return nil
        }
    }
}

extension Purchases: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            print("Found 0 products")

            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
            return
        }

        var products = [String: SKProduct]()
        for skProduct in response.products {
            print("Found product: \(skProduct.productIdentifier)")
            products[skProduct.productIdentifier] = skProduct
        }

        self.products = products

        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")

        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}
