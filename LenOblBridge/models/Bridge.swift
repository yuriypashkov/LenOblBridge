

import Foundation
import MapKit
import Contacts

struct Bridge: Decodable {
    
    var id: Int?
    var title: String?
    var river: String?
    var year: String?
    var length: String?
    var width: String?
    var architect: String?
//    var engineer: String?
    var about: String?
    var road: String?
    var mainImageURL: String?
    var previewImageURL: String?
    var latitude: Double?
    var longtitude: Double?
    
}

class BridgeAnnotation: NSObject, MKAnnotation {
    let title: String?
    let river: String?
    let coordinate: CLLocationCoordinate2D
    let bridgeObject: Bridge? // странное свойство для вызова нового VC по тапу на вьюаннотейшн из MapViewController
    
    var mapItem: MKMapItem? {
        
        guard let location = river else { return nil }
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        return mapItem
    }
    
    var subtitle: String? {
        return river
    }
    
    init(title: String?, river: String?, coordinate: CLLocationCoordinate2D, bridgeObject: Bridge) {
        self.title = title
        self.river = river
        self.coordinate = coordinate
        self.bridgeObject = bridgeObject
    }
}
