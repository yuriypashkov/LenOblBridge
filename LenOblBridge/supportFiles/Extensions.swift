
import Foundation
import UIKit



extension UIImageView {
    
    func lazyImageDownload(url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {self.image = UIImage(data: data)}
            }
        }.resume()
    }
    
    
    
//    func loadImageWithUrl(url: URL) {
//        var imageURL: URL?
//        let activityIndicator = UIActivityIndicatorView()
//        let imageCache = NSCache<AnyObject, AnyObject>()
//        
//        activityIndicator.color = .darkGray
//        activityIndicator.center = self.center
//        addSubview(activityIndicator)
//        
//        imageURL = url
//        image = nil
//        activityIndicator.startAnimating()
//        
//        // print all objects in cache
//        if let all = imageCache.value(forKey: "allObjects") as? NSArray {
//            for object in all {
//                print("object is \(object)")
//            }
//        }
//        
//        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            activityIndicator.stopAnimating()
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//            if error != nil {
//                print(error as Any)
//                DispatchQueue.main.async(execute: {
//                    activityIndicator.stopAnimating()
//                })
//                return
//            }
//
//            DispatchQueue.main.async(execute: {
//                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
//                    if imageURL == url {
//                        self.image = imageToCache
//                    }
//                    
//                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
//                }
//                activityIndicator.stopAnimating()
//            })
//        }).resume()
//        
//    }
    
}

