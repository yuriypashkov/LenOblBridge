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
    //var completion: ((Bool) -> Void)?
    var completion: ((Result<Bool, Error>) -> Void)?

    static let shared = PurchaseManager()
    
    func fetchProducts() {
//        SKPaymentQueue.default().add(self)
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
        //SKPaymentQueue.default().add(self) // создание наблюдателя можно повесить в AppDelegate и удалять его по заврешению приложения
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func restore(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard self.completion == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        
        self.completion = completion
        //SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //for transaction in queue.transactions {
        print("PURCHASE RESTORED: \(queue.transactions)")
        //}
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("RESTORE WITH ERROR METHOD")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased, .restored:
               if myFinishTransaction(transaction) {
                    completion?(.success(true))
                    SKPaymentQueue.default().finishTransaction(transaction)
                    //SKPaymentQueue.default().remove(self) // если покупок в приложении больше одной - удалять наблюдатель нельзя
                    self.completion = nil // по идее тоже надо очищать колбэк (хотя у нас одна покупка и можно не очищать)
                } else {
                    completion?(.failure(PurchasesError.unknown))
                }
            case .failed:
                guard let skError = transaction.error as? SKError else {
                    print("NO CAST")
                    return}
                
                print(skError.code.self)
                if skError.code == .paymentCancelled {
                    completion?(.success(false))
                } else {
                    completion?(.failure(transaction.error ?? PurchasesError.unknown))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                self.completion = nil // как будто нужно здесь, для обработки кнопки Отмена или ошибка при платеже
            default:
                print("DEFAULT") // сюда заходит при попытке повторной покупки
                break
            }
        }
        
        //completion = nil
    }
    
    //applicationWillTerminate
    
    func myFinishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        print("Product \(productId) successfully purchased")
        return true
    }
    
}
