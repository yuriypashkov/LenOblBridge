////
////  Purchases.swift
////  LenOblBridge
////
////  Created by Yuriy Pashkov on 2/25/21.
////  Copyright © 2021 Yuriy Pashkov. All rights reserved.
////
//
//import Foundation
//import StoreKit
//
//class Purchases: NSObject {
//    
//    typealias RequestProductsResult = Result<[SKProduct], Error>
//    typealias PurchaseProductResult = Result<Bool, Error>
//
//    typealias RequestProductsCompletion = (RequestProductsResult) -> Void
//    typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void
//    
//
//    
//    static let `default` = Purchases()
//    private let productIdentifiers = Set<String>(
//        arrayLiteral: "lenOblBridgeAdCancel"
//    )
//    
//    private var products: [String: SKProduct]?
//    private var productRequest: SKProductsRequest?
//    
//    func initialize(completion: @escaping RequestProductsCompletion) {
//        requestProducts(completion: completion)
//    }
//    
//    private var productsRequestCallbacks = [RequestProductsCompletion]()
//    
//    private func requestProducts(completion: @escaping RequestProductsCompletion) {
//        guard productsRequestCallbacks.isEmpty else {
//            productsRequestCallbacks.append(completion)
//            return
//        }
//
//        productsRequestCallbacks.append(completion)
//
//        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
//        productRequest.delegate = self
//        productRequest.start()
//
//        self.productRequest = productRequest
//    }
//    
//    // MARK: - Purchase and restore methods
//    
//    fileprivate var productPurchaseCallback: ((PurchaseProductResult) -> Void)?
//    
//    func purchaseProduct(productId: String, completion: @escaping (PurchaseProductResult) -> Void) {
//
//        guard productPurchaseCallback == nil else {
//            completion(.failure(PurchasesError.purchaseInProgress))
//            print("NIL")
//            return
//        }
//
//        guard let product = products?[productId] else {
//            completion(.failure(PurchasesError.productNotFound))
//            print("NOT FOUND")
//            return
//        }
//
//        productPurchaseCallback = completion
//
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//    
//    public func restorePurchases(completion: @escaping (PurchaseProductResult) -> Void) {
//        guard productPurchaseCallback == nil else {
//            completion(.failure(PurchasesError.purchaseInProgress))
//            return
//        }
//        productPurchaseCallback = completion
//
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//    
//    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
//        let productId = transaction.payment.productIdentifier
//        print("Product \(productId) successfully purchased")
//        return true
//    }
//    
//}
//
//extension SKProduct {
//    
//    var localizedPrice: String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = priceLocale
//        return formatter.string(from: price)!
//    }
//
//    var title: String? {
//        switch productIdentifier {
//        case "lenOblBridgeAdCancel":
//            return "Отключить рекламу"
//        default:
//            return nil
//        }
//    }
//}
//
//extension Purchases: SKProductsRequestDelegate, SKPaymentTransactionObserver {
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        
//        for transaction in transactions {
//            print("TRANSACTION")
//            switch transaction.transactionState {
//
//            case .purchased, .restored:
//                if finishTransaction(transaction) {
//                    SKPaymentQueue.default().finishTransaction(transaction)
//                    productPurchaseCallback?(.success(true))
//                } else {
//                    productPurchaseCallback?(.failure(PurchasesError.unknown))
//                }
//
//            case .failed:
//                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
//                SKPaymentQueue.default().finishTransaction(transaction)
//            default:
//                break
//            }
//        }
//
//        productPurchaseCallback = nil
//    }
//    
//    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        guard !response.products.isEmpty else {
//            print("Found 0 products")
//
//            productsRequestCallbacks.forEach { $0(.success(response.products)) }
//            productsRequestCallbacks.removeAll()
//            return
//        }
//
//        var products = [String: SKProduct]()
//        for skProduct in response.products {
//            print("Found product: \(skProduct.productIdentifier)")
//            products[skProduct.productIdentifier] = skProduct
//        }
//
//        self.products = products
//
//        productsRequestCallbacks.forEach { $0(.success(response.products)) }
//        productsRequestCallbacks.removeAll()
//    }
//    
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Failed to load products with error:\n \(error)")
//
//        productsRequestCallbacks.forEach { $0(.failure(error)) }
//        productsRequestCallbacks.removeAll()
//    }
//}
