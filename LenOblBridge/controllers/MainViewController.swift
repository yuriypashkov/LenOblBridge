
import UIKit

protocol MainDelegate: class {
    func tableViewReload()
    func updateInternetErrorLabel(showError: Bool, isSomeContent: Bool, textError: String)
    var activityIndicator: UIActivityIndicatorView {get}
}

class MainViewController: UIViewController, MainDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var internetErrorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    let bridgesModel = BridgesModel()
    var filteredBridges = [Bridge]()
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let activityIndicator = UIActivityIndicatorView()
    var mainRefreshControl = UIRefreshControl()
    
    func tableViewReload() {
        tableView.reloadData()
    }
    
    func updateInternetErrorLabel(showError: Bool, isSomeContent: Bool, textError: String) {
        internetErrorLabel.text = textError
        internetErrorLabel.alpha = (showError && !isSomeContent) ? 1 : 0
        errorViewLabel.text = textError
        errorView.alpha = (showError && isSomeContent) ? 1 : 0
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        bridgesModel.loadData()
        sender.endRefreshing()
    }
    
    // must strong IBOutlet иначе значение не возвращается после отмены поиска
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var infoButton: UIBarButtonItem!
    
    
    
    @IBAction func searchButtonTap(_ sender: UIBarButtonItem) {
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    @IBAction func infoButtonTap(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoViewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController")
        //infoViewController.modalPresentationStyle = .fullScreen
        present(infoViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        bridgesModel.delegate = self
        
        // searchcontroller настройки
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false //важное свойство чтоб нажимать на ячейки во время поиска
        self.definesPresentationContext = true
        
        // индикатор загрузки контента
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // подключаем pull refresh
        mainRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = mainRefreshControl
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredBridges.count
        }
        
        guard let count = bridgesModel.parsedBridges else { return 0 }
        return count.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        
        if !isFiltering {
            cell.setData(imageName: bridgesModel.parsedBridges?[indexPath.row].previewImageURL ?? "None",
                                     title: bridgesModel.parsedBridges?[indexPath.row].title ?? "None")}
        else {
            cell.setData(imageName: filteredBridges[indexPath.row].previewImageURL ?? "None",
                                    title: filteredBridges[indexPath.row].title ?? "None")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bridgeViewController = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? BridgeViewController else { return }
        
        if !isFiltering {
            bridgeViewController.currentBridge = bridgesModel.parsedBridges?[indexPath.row]
        }
        else {
            bridgeViewController.currentBridge = filteredBridges[indexPath.row]
        }
        
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
}



