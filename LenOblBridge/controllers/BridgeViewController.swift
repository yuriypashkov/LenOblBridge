import UIKit
import MapKit

class BridgeViewController: UIViewController {

    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var characterStackView: UIStackView!
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    @IBOutlet weak var engineerValueLabel: SelectableLabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func shareButtonTap(_ sender: UIButton) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.systemGray.cgColor
        colorAnimation.duration = 1  // animation duration
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        sender.layer.cornerRadius = sender.frame.width / 2
        if let image = photoImageView.image, let bridgeName = currentBridge.title {
            let message = "Потрясающий воображение \(bridgeName), находящийся в Ленинградской области. Узнать о нём, а также о множестве других интересных мостах Ленинградской области, можно, скачав приложение: https://apps.apple.com/ru/app/id1543536938"
            let vc = UIActivityViewController(activityItems: [image, message], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    var currentBridge: Bridge!
    var bridgeAnnotation: BridgeAnnotation!
    //var tabBar: CustomTabController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBottomConstraint(constraint: scrollViewBottomConstraint)
        
        // настройка контроллера и карты
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        setupLabels()
        setupMap()
        
        // ставим метку на карте
        if let currentBridge = currentBridge {
            bridgeAnnotation = BridgeAnnotation(title: currentBridge.title, river: currentBridge.river, coordinate: CLLocationCoordinate2D(latitude: currentBridge.latitude!, longitude: currentBridge.longtitude!), bridgeObject: currentBridge)
            mapView.addAnnotation(bridgeAnnotation)
        }
        // делегат для использования annotationView
        mapView.delegate = self

        // обработчик тапа по картинке с мостом
        photoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let labelColorGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        labelColorGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(labelColorGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.hidesBarsOnTap = false
        //tabBarController?.tabBar.isHidden = true
        //tabBar?.tabBar.isHidden = true
        //tabBar?.containerView.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //tabBarController?.tabBar.isHidden = false
        //tabBar?.tabBar.isHidden = false
        //tabBar?.containerView.alpha = 1
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let fullSizeVC = FullScreenImageViewController()
        fullSizeVC.imageToShow = photoImageView.image
        self.navigationController?.pushViewController(fullSizeVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        engineerValueLabel.backgroundColor = .clear
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
        if let latitude = currentBridge.latitude, let longtitude = currentBridge.longtitude {
            engineerValueLabel.text = "\(latitude), \(longtitude)"
        }
    }
    
    func setupMap() {
        if let latitude = currentBridge.latitude, let longtitude = currentBridge.longtitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }

}

extension BridgeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BridgeAnnotation else { return nil}
        let identifier = "bridge"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: -5)
            let button = UIButton(type: .detailDisclosure)
            button.setImage(UIImage(named: "walkingMan"), for: .normal)
            button.tintColor = .black
            view.rightCalloutAccessoryView = button
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let bridge = view.annotation as? BridgeAnnotation else {return}
        
        let launchOptions = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving ]
        bridge.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}
