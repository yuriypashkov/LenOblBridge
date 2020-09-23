
import UIKit

class BridgeViewController: UIViewController {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var characterStackView: UIStackView!
    
    @IBOutlet weak var bridgeTitleLabel: UILabel!
    @IBOutlet weak var waterValueLabel: UILabel!
    @IBOutlet weak var foundationValueLabel: UILabel!
    @IBOutlet weak var lengthValueLabel: UILabel!
    @IBOutlet weak var widthValueLabel: UILabel!
    @IBOutlet weak var architectValueLabel: UILabel!
    @IBOutlet weak var engineerValueLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func shareButtonTap(_ sender: UIButton) {
        print("TAP")
    }
    
    var currentBridge: BridgeObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setupLabels() {
        bridgeTitleLabel.text = currentBridge.title
        photoImageView.image = UIImage(named: currentBridge.mainImageName)
        foundationValueLabel.text = currentBridge.year
        architectValueLabel.text = currentBridge.architect
        aboutLabel.text = currentBridge.about
        tripLabel.text = currentBridge.road
    }



}
