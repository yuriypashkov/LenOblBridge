
import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {
    
    var imageURL: URL?
    let activityIndicator = UIActivityIndicatorView()
    
    func newLoadImageWithUrl(url: URL) {
        
        activityIndicator.color = .darkGray
        activityIndicator.center = self.center
        addSubview(activityIndicator)
        
//                if let all = imageCache.value(forKey: "allObjects") as? NSArray {
//                    for object in all {
//                        print("object is \(object)")
//                    }
//                }
        
        imageURL = url
        image = nil
        activityIndicator.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            print("INAGE FROM CACHE")
            activityIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                        print("IMAGE FROM INTERNET")
                    }
                    
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
        
    }
    
}
