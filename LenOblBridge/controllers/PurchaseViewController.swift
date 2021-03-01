//
//  PurchaseViewController.swift
//  LenOblBridge
//
//  Created by Yuriy Pashkov on 3/1/21.
//  Copyright © 2021 Yuriy Pashkov. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {
    
    @IBOutlet weak var buyButton: UIButton!
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.color = .red
        
        showIndicator()

        Purchases.default.initialize { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator()
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.updateButton(self.buyButton, with: products[0])
                }
            case .failure:
                print("FAIL")
                break
            }
        }
        
    }

    @IBAction func buyButtonTap(_ sender: UIButton) {
        
    }
    
    @IBAction func restoreButtonTap(_ sender: UIButton) {
        
    }
    
}

extension PurchaseViewController {
    
    func updateButton(_ button: UIButton, with product: SKProduct) {
        let title = "\(product.title ?? product.productIdentifier) за \(product.localizedPrice)"
        
        button.setTitle(title, for: .normal)
    }
    
    func showIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
}
