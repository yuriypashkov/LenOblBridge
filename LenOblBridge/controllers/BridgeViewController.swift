
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
    
    var currentBridge: Bridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        
        photoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let fullSizeVC = FullScreenImageViewController()
        fullSizeVC.imageToShow = photoImageView.image
        self.navigationController?.pushViewController(fullSizeVC, animated: true)
    }

    
    func setupLabels() {
        bridgeTitleLabel.text = currentBridge.title
        if let url = URL(string: currentBridge.mainImageURL!) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: url)
        }
        foundationValueLabel.text = currentBridge.year
        architectValueLabel.text = currentBridge.architect
        aboutLabel.text = currentBridge.about
        tripLabel.text = currentBridge.road
        waterValueLabel.text = currentBridge.river
        lengthValueLabel.text = currentBridge.length
        widthValueLabel.text = currentBridge.width
        engineerValueLabel.text = currentBridge.engineer
    }



}
