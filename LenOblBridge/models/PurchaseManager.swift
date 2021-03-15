//
//  PurchaseModel.swift
//  LenOblBridge
//
//  Created by Yuriy Pashkov on 3/2/21.
//  Copyright © 2021 Yuriy Pashkov. All rights reserved.
//

import Foundation
import StoreKit

final class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var products = [SKProduct]()
    var completion: ((Result<Bool, Error>) -> Void)?

    static let shared = PurchaseManager()
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["lenOblBridgeAdCancel"])
        request.delegate = self
        request.start()
    }
    
    // delegate-method, called after request.start() finished
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print("product name is: \(product.productIdentifier)")
        }
        products = response.products
    }
    
    func purchase(completion: @escaping (Result<Bool, Error>) -> Void) { // @escaping ((Bool) -> Void)
        guard SKPaymentQueue.canMakePayments() else {
            completion(.failure(PurchasesError.doNotCanMakePayments))
            return}
        
        guard self.completion == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return}
        
        guard let storeKitProduct = products.first else {
            completion(.failure(PurchasesError.productNotFound))
            return}
        
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func restore(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard self.completion == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        
        self.completion = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // если идет попытка восстановить несовершенную покупку
        if queue.transactions.isEmpty {
            completion?(.success(false))
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        completion?(.success(false))
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased, .restored:
               if myFinishTransaction(transaction) {
                    completion?(.success(true))
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.completion = nil // по идее тоже надо очищать колбэк (хотя у нас одна покупка и можно не очищать)
                } else {
                    completion?(.failure(PurchasesError.unknown))
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                guard let skError = transaction.error as? SKError else { return }
                if skError.code == .paymentCancelled {
                    completion?(.success(false))
                } else {
                    completion?(.failure(transaction.error ?? PurchasesError.unknown))
                }
                self.completion = nil // как будто нужно здесь, для обработки кнопки Отмена или ошибка при платеже
            default:
                // сюда заходит при попытке повторной покупки
                break
            }
        }
    }
    
    func myFinishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        print("Product \(productId) successfully purchased")
        return true
    }
    
}
