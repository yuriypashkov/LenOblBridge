
import Foundation
import UIKit

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


