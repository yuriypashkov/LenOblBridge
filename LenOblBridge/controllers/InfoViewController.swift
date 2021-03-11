
import UIKit
import MessageUI

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    var infoModel = InfoModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModel.data.count
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentInfoModel = infoModel[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        switch currentInfoModel.cellType {
        case .email:
            cell?.lightningCell()
            if MFMailComposeViewController.canSendMail() {
                sendEmail()
            }
        case .rank:
            cell?.lightningCell()
            if let url = URL(string: currentInfoModel.url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .header:
            ()
        case .purchase:
            cell?.lightningCell()
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let purchaseViewController = storyboard.instantiateViewController(withIdentifier: "PurchaseViewController") as! PurchaseViewController
            purchaseViewController.modalPresentationStyle = .fullScreen
            purchaseViewController.delegate = self
            present(purchaseViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentInfoModel = infoModel[indexPath.row]
        
        // для первой яейчки отдельный класс
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderAboutCell") as! HeaderAboutCell
            cell.setCell(imageName: currentInfoModel.imageName, title: currentInfoModel.title, about: currentInfoModel.aboutText)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as! AboutCell
            cell.setCell(imageName: currentInfoModel.imageName, title: currentInfoModel.title, about: currentInfoModel.aboutText)
            return cell
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // состояние рекламы
        setBottomConstraint(constraint: tableViewBottomConstraint)
        
        if !UserDefaults.standard.bool(forKey: "isPurchaseADCancelDone") {
            let adCell = InfoCellData(imageName: "iconPurchase", title: "Убрать рекламу", aboutText: "Заплатить 99 р. и убрать рекламу из приложения", cellType: .purchase)
            infoModel.data.append(adCell)
        }
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
    }
    
    func sendEmail() {
        let mail = MFMailComposeViewController()
        let osVersion = UIDevice.current.systemVersion
        mail.mailComposeDelegate = self
        mail.setToRecipients(["yuriy.pashkov@gmail.com"])
        mail.setSubject("Сообщение из приложения Мосты Ленинградской Области")
        mail.setMessageBody("Версия iOS: \(osVersion)</p><p>Напишите что-нибудь:</p><br><br><br><br>", isHTML: true)
        present(mail, animated: true, completion: nil)
    }
    
}

extension InfoViewController: InfoDelegate {
    
    func removeCellAndReloadTable() {
        if infoModel.data.count > 3 {
            infoModel.data.removeLast()
            tableView.reloadData()
        }
    }
    
}
