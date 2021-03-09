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
    
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView()
    
    var delegate: InfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup Activityindicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.color = .systemRed
        view.addSubview(activityIndicator)
        
        aboutLabel.text = """
        • Надоело лицезреть жалкий баннер в нижней части экрана?

        • Реклама отвлекает от чтения замечательных историй про мосты?

        • Экзистенциальный кризис уже дышит в спину?
        """
        happyLabel.text = """
        Всего за 99 RUB ты можешь убрать надоедливый баннер.

        Реклама уйдёт навсегда, а вместе с ней любая хандра и плохое настроение.
        """
    }

    @IBAction func buyButtonTap(_ sender: UIButton) {
        activityIndicator.startAnimating()
        blockElements()
        PurchaseManager.shared.purchase { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bool):
                    if bool {
                        UserDefaults.standard.setValue(true, forKey: "isPurchaseADCancelDone")
                        self.setupUIAfterPurchase(text: "Покупка завершена!")
                    } else {
                        self.unlockElements()
                    }
                case .failure:
                    //print(error)
                    //show info about error
                    let errorAlert = UIAlertController(title: "Ошибка", message: "В процессе покупки произошла ошибка. Попробуйте ещё раз.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlert.addAction(action)
                    self.present(errorAlert, animated: true, completion: nil)
                    self.unlockElements()
                }
            }
        }
    }
    
    @IBAction func restoreButtonTap(_ sender: UIButton) {
        activityIndicator.startAnimating()
        blockElements()
        PurchaseManager.shared.restore { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let bool):
                    if bool {
                        UserDefaults.standard.setValue(true, forKey: "isPurchaseADCancelDone")
                        self.setupUIAfterPurchase(text: "Восстановление завершено!") 
                    } else {
                        self.unlockElements()
                    }
                case .failure:
                    //print(error)
                    let errorAlert = UIAlertController(title: "Ошибка", message: "В процессе покупки произошла ошибка. Попробуйте ещё раз.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlert.addAction(action)
                    self.present(errorAlert, animated: true, completion: nil)
                    self.unlockElements()
                }
            }
        }
        
    }
    
    
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        dismissController()
    }
    
    @IBAction func agreeButtonTap(_ sender: UIButton) {
        dismissController()
    }
    
    private func blockElements() {
        buyButton.isEnabled = false
        restoreButton.isEnabled = false
        closeButton.isEnabled = false
        view.alpha = 0.66
    }
    
    private func dismissController() {
        dismiss(animated: true) {
            if UserDefaults.standard.bool(forKey: "isPurchaseADCancelDone") {
                print("DELETE CELL")
                self.delegate?.removeCellAndReloadTable()
            } else {
                print("NOT DELETE CELL")
            }
        }
    }
    
    private func unlockElements() {
        view.alpha = 1
        closeButton.isEnabled = true
        buyButton.isEnabled = true
        restoreButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
}

extension PurchaseViewController {
    
    func setupUIAfterPurchase(text: String) {
        closeButton.isEnabled = true
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
            self.happyLabel.alpha = 0
            self.aboutLabel.alpha = 0
            self.buyButton.alpha = 0
            self.restoreButton.alpha = 0
            self.headerLabel.text = "ДЕЛО СДЕЛАНО"
            self.thanksLabel.alpha = 1
            self.thanksLabel.text = """
            \(text)
            Перезапустите приложение для отключения рекламы.
            """
            self.agreeButton.alpha = 1
        }

    }
    
}
