import UIKit

class BridgeViewController: UIViewController {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var characterStackView: UIStackView!
    
    @IBOutlet weak var titleSubview: UIView!
    @IBOutlet weak var aboutSubview: UIView!
    @IBOutlet weak var charactersSubview: UIView!
    @IBOutlet weak var photoSubview: UIView!
    
    @IBOutlet weak var bridgeTitleLabel: UILabel!
    @IBOutlet weak var waterValueLabel: UILabel!
    @IBOutlet weak var foundationValueLabel: UILabel!
    @IBOutlet weak var lengthValueLabel: UILabel!
    @IBOutlet weak var widthValueLabel: UILabel!
    @IBOutlet weak var architectValueLabel: UILabel!
    @IBOutlet weak var engineerValueLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func shareButtonTap(_ sender: UIButton) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.systemGray.cgColor
        colorAnimation.duration = 1  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        sender.layer.cornerRadius = sender.frame.width / 2
        if let image = photoImageView.image, let bridgeName = currentBridge.title {
            let message = "Потрясающий воображение \(bridgeName), находящийся в Ленинградской области. Узнать о нём, а также о множестве других интересных мостах Ленинградской области, можно, скачав приложение: <ссылка>"
            let vc = UIActivityViewController(activityItems: [image, message], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    var currentBridge: Bridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        
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
            //photoImageView.kf.setImage(with: url)
            photoImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (_) in
                UIView.animate(withDuration: 0.5) {
                    self.shareButton.alpha = 1.0
                }
            }
        }
        foundationValueLabel.text = currentBridge.year
        architectValueLabel.text = currentBridge.architect
        aboutLabel.text = currentBridge.about?.russianHyphenated()
        tripLabel.text = currentBridge.road?.russianHyphenated()
        waterValueLabel.text = currentBridge.river
        lengthValueLabel.text = currentBridge.length
        widthValueLabel.text = currentBridge.width
        engineerValueLabel.text = currentBridge.engineer
    }
    
    func setupGradients() {
        if let gradientColor = CAGradientLayer.primaryGradient(on: charactersSubview) {
            charactersSubview.backgroundColor = UIColor(patternImage: gradientColor)
            aboutSubview.backgroundColor = UIColor(patternImage: gradientColor)
            photoSubview.backgroundColor = UIColor(patternImage: gradientColor)
            view.backgroundColor = titleSubview.backgroundColor
        }
    }



}
