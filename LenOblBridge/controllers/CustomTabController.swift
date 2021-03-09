//
//  CustomTabController.swift
//  LenOblBridge
//
//  Created by Yuriy Pashkov on 3/3/21.
//  Copyright © 2021 Yuriy Pashkov. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class CustomTabController: UITabBarController, GADBannerViewDelegate {
    
    // MARK: - Properties
    var containerView = GADBannerView()
    
    // MARK: - VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.delegate = self
        
        if !UserDefaults.standard.bool(forKey: "isPurchaseADCancelDone") {
            configureAD()
        }
        
    }
    
    // MARK: - Other methods
    func configureAD() {
                                
        containerView.rootViewController = self
        containerView.adUnitID = "ca-app-pub-7211921803083081/6283013149"
        containerView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        containerView.translatesAutoresizingMaskIntoConstraints = true
        let tabBarHeight = tabBar.frame.size.height
        var bottomInset = view.frame.size.height - tabBarHeight - 60
        if let window = UIApplication.shared.windows.first {
            bottomInset -= window.safeAreaInsets.bottom
        }
        containerView.frame = CGRect(x: 0, y: bottomInset, width: view.frame.width, height: 60)
        containerView.load(GADRequest())
        view.addSubview(containerView)
  
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
