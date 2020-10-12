
import Foundation
import UIKit



//extension UIImageView {
//
//    func lazyImageDownload(url: String) {
//        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
//            DispatchQueue.main.async {
//                if let data = data {self.image = UIImage(data: data)}
//            }
//        }.resume()
//    }
//    
//
//}

extension Error {

    var isConnectivityError: Bool {
        // let code = self._code || Can safely bridged to NSError, avoid using _ members
        let code = (self as NSError).code

        if (code == NSURLErrorTimedOut) {
            return true // time-out
        }

        if (self._domain != NSURLErrorDomain) {
            return false // Cannot be a NSURLConnection error
        }

        switch (code) {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
            return true
        default:
            return false
        }
    }

}

