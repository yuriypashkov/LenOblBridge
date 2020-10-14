
import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Приложение Горшкометр носит сугубо развлекательный характер. Все совпадения с реально-существующими личностями случайны. Мы благодарим группу \"Король и Шут\" за вдохновение, всем однозначно ХОЙ! По всем вопросам и предложениям можно писать авторам. При нажатии на кнопки ниже вы будете перенаправлены на внешние ресурсы".russianHyphenated()

    }
    

}
