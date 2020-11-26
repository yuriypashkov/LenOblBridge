
import Foundation
import UIKit

// расширение для отрисовки градиентов
extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let colorOne = UIColor(red: 0.56, green: 0.62, blue: 0.67, alpha: 1.00)
        let colorTwo = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.00)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

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

extension MainViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if let parsedBridges = bridgesModel.parsedBridges {
            filteredBridges = parsedBridges.filter({ (bridge: Bridge) -> Bool in
                return (bridge.about?.lowercased().contains(searchText.lowercased()))!
            })
        }
        tableViewReload()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewReload()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.titleView = nil
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.leftBarButtonItem = self.searchButton
        self.navigationItem.rightBarButtonItem = self.infoButton
    }
}

extension String {
    func russianHyphenated() -> String {
        return hyphenated(locale: Locale(identifier: "ru_Ru"))
    }

    func hyphenated(languageCode: String) -> String {
        let locale = Locale(identifier: languageCode)
        return self.hyphenated(locale: locale)
    }

    func hyphenated(locale: Locale) -> String {
        guard CFStringIsHyphenationAvailableForLocale(locale as CFLocale) else { return self }
        
        var s = self
        
        let fullRange = CFRangeMake(0, s.utf16.count)
        var hyphenationLocations = [CFIndex]()
        
        for (i, _) in s.utf16.enumerated() {
            let location: CFIndex = CFStringGetHyphenationLocationBeforeIndex(s as CFString, i, fullRange, 0, locale as CFLocale, nil)
            if hyphenationLocations.last != location {
                hyphenationLocations.append(location)
            }
        }
        
        for l in hyphenationLocations.reversed() {
            guard l > 0 else { continue }
            let strIndex = String.Index(utf16Offset: l, in: s)
            // insert soft hyphen:
            s.insert("\u{00AD}", at: strIndex)
            // or insert a regular hyphen to debug:
            //s.insert("-", at: strIndex)
        }
        
        return s
    }
}



