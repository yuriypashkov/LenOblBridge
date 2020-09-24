
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
        //navigationController?.hidesBarsOnTap = true
        setupLabels()
        
        photoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let fullSizeVC = FullScreenImageViewController()
        //fullSizeVC.imageUrl = currentBridge.mainImageURL
        fullSizeVC.imageToShow = photoImageView.image
        self.navigationController?.pushViewController(fullSizeVC, animated: true)
    }

    
    func setupLabels() {
        bridgeTitleLabel.text = currentBridge.title
        photoImageView.image = UIImage(named: "tempImage")
        photoImageView.lazyImageDownload(url: currentBridge.mainImageURL!)
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
