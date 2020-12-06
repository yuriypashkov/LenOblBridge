
import Foundation

struct InfoModel {
    
    var data = [
        InfoCellData(imageName: "mainInvert300", title: "Мосты Ленинградской области", aboutText: "  С помощью этого приложения вы сможете ознакомиться с большим количеством мостов, возведённых в Ленинградской области. Увидеть их на фотографиях, изучить истории их постройки и существования. Быть может, вы даже захотите лично увидеть каждый из этих мостов и прикоснуться к каждому из них руками.\n   Приложение носит исключительно юмористический характер, все совпадения с реально-существующими людьми случайны."),
        InfoCellData(imageName: "iconRate2", title: "Оценить приложение", aboutText: "Оставьте отзыв и оценку в AppStore", url: "https://apps.apple.com/ru/app/id1517319081"),
        InfoCellData(imageName: "iconMail2", title: "Обратная связь", aboutText: "Написать разработчику, предложения, недочёты, пожелания", isEmail: true)
    ]
    
    subscript(index: Int) -> InfoCellData {
        get {
            return data[index]
        }
    }
    
}
