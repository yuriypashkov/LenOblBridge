
import UIKit
import MessageUI

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let infoModel = InfoModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModel.data.count
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentInfoModel = infoModel[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if currentInfoModel.isEmail {
            cell?.lightningCell()
            if MFMailComposeViewController.canSendMail() {
                sendEmail()
            }
        }
        else {
            if let url = URL(string: currentInfoModel.url), UIApplication.shared.canOpenURL(url) {
                cell?.lightningCell()
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
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
