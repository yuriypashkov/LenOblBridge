
import Foundation


class BridgesBank {

    var bridgesArray = [BridgeObject]()
    
    init() {
        bridgesArray.append(BridgeObject(imagePreviewName: "image_1_preview", mainImageName: "image1", title: "ЛУНАЧАРСКИЙ МОСТ", year: "1893", architect: "А.В. Луначарский", about: aboutBridgeOne, road: roadBridgeOne))
        bridgesArray.append(BridgeObject(imagePreviewName: "image_2_preview", mainImageName: "image2", title: "ДВЕРНОЙ МОСТ", year: "1882", architect: "М.Ф. Андерсин", about: aboutBridgeTwo, road: roadBridgeTwo))
        bridgesArray.append(BridgeObject(imagePreviewName: "image_3_preview", mainImageName: "image3", title: "МОСТ ЛЕ НОЛЕАМ", year: "1871", architect: "Н. Казуро", about: aboutBridgeThree, road: roadBridgeThree))
    }
    
}
