

import Foundation
import UIKit

class BridgesModel {
    
    var parsedBridges: [Bridge]?
    weak var delegate: MainDelegate?
    
    init() {
       loadData()
    }
    
    func asyncAction(isErrorShow: Bool, errorText: String){
        DispatchQueue.main.async {
            self.delegate?.activityIndicator.removeFromSuperview()
            self.delegate?.updateInternetErrorLabel(showError: isErrorShow, isSomeContent: self.parsedBridges != nil, textError: errorText)
        }
    }
    
    func loadData() {
        
        let urlString = "https://39420617afb9.ngrok.io/bridges"
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                if error != nil {
                    if error!.isConnectivityError {
                        self.asyncAction(isErrorShow: true, errorText: "Проблема с интернет-соединением. Проверьте настройки интернета")
                    } else {
                        self.asyncAction(isErrorShow: true, errorText: "Возникла неизвестная ошибка. Попробуйте перезапустить приложение")
                    }
                }
                
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Status code: \(httpResponse.statusCode)")
                        switch httpResponse.statusCode {
                        case 200:
                            self.parsedBridges = try JSONDecoder().decode([Bridge].self, from: data!)
                            DispatchQueue.main.async { self.delegate?.tableViewReload() }
                            self.asyncAction(isErrorShow: false, errorText: "")
                        case 400...406:
                            self.asyncAction(isErrorShow: true, errorText: "Проблема с запросом. Попробуйте запустить приложение позднее")
                        case 500...505:
                            self.asyncAction(isErrorShow: true, errorText: "Проблема с сервером. Попробуйте запустить приложение позднее")
                        default:
                            self.asyncAction(isErrorShow: true, errorText: "Возникла неизвестная ошибка. Попробуйте перезапустить приложение")
                        }
                    }
            
                }
            catch {
                    print(error)
                }
            }
        
        task.resume()
        
    }
    
}
