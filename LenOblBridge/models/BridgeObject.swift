
import Foundation

class BridgeObject {
    
    var imagePreviewName: String
    var mainImageName: String
    var title: String
    var year: String
    var architect: String
    var about: String
    var road: String
    
    init(imagePreviewName: String, mainImageName: String, title: String, year: String, architect: String, about: String, road: String) {
        self.imagePreviewName = imagePreviewName
        self.title = title
        self.mainImageName = mainImageName
        self.year = year
        self.architect = architect
        self.about = about
        self.road = road
    }
    
}
