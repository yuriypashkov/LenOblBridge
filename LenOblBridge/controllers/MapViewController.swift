
import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var bridges: [Bridge] = []
    let networkModel = NetworkModel()
    let activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    @IBAction func errorButtonTap(_ sender: UIButton) {
        loadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        errorButton.layer.cornerRadius = 8
        errorButton.layer.masksToBounds = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        setupMap()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func loadData() {
        showLoading()
        networkModel.getBridges { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tempBridges):
                    self.bridges = tempBridges
                    // addAnnotations
                    self.showAnnotations()
                    self.showMap()
                case .failure:
                    self.bridges = []
                    self.showError()
                }
            }
        }
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        errorLabel.alpha = 0
        errorButton.alpha = 0
    }
    
    func showMap() {
        activityIndicator.stopAnimating()
        errorLabel.alpha = 0
        errorButton.alpha = 0
    }
    
    func showError() {
        activityIndicator.stopAnimating()
        errorLabel.alpha = 1
        errorButton.alpha = 1
    }
    
    func showAnnotations() {
        for bridge in bridges {
            if let latitude = bridge.latitude, let longtitude = bridge.longtitude {
                let bridgeAnnotation = BridgeAnnotation(title: bridge.title, river: bridge.river, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), bridgeObject: bridge)
                mapView.addAnnotation(bridgeAnnotation)
            }
        }
    }
    
    func setupMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.940329, longitude: 30.309455)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    
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
            button.tintColor = .black
            view.rightCalloutAccessoryView = button
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let bridge = view.annotation as? BridgeAnnotation else {return}
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let bridgeViewController = storyboard.instantiateViewController(withIdentifier: "TestViewController") as! BridgeViewController
        bridgeViewController.currentBridge = bridge.bridgeObject
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
    
}
