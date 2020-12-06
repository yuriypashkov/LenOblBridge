
import UIKit

//protocol MainDelegate: class {
//    func tableViewReload()
//    func updateInternetErrorLabel(showError: Bool, isSomeContent: Bool, textError: String)
//    var activityIndicator: UIActivityIndicatorView {get}
//}

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var bridges: [Bridge] = []
    var filteredBridges: [Bridge] = []
    var networkModel = NetworkModel()
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let activityIndicator = UIActivityIndicatorView()
    var mainRefreshControl = UIRefreshControl()
    
    @objc func refresh(sender: UIRefreshControl) {
        reloadData()
        sender.endRefreshing()
    }
    
    // must strong IBOutlet иначе значение не возвращается после отмены поиска
    @IBOutlet var searchButton: UIBarButtonItem!
    //@IBOutlet var infoButton: UIBarButtonItem!
    
    @IBAction func searchButtonTap(_ sender: UIBarButtonItem) {
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.leftBarButtonItem = nil
        //self.navigationItem.rightBarButtonItem = nil
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // иконки для iOS < 13
        if #available(iOS 13.0, *) {} else {
            navigationItem.leftBarButtonItem?.image = UIImage(named: "search25px")
            //navigationItem.rightBarButtonItem?.image = UIImage(named: "info35px")
        }
        
        // загружаем данные
        reloadData()

        // searchcontroller настройки
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false //важное свойство чтоб нажимать на ячейки во время поиска
        self.definesPresentationContext = true
        
        // индикатор загрузки контента
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // подключаем pull refresh
        mainRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = mainRefreshControl
        
        //tabBarController?.tabBarItem.title = nil
        //tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    func reloadData() {
        networkModel.getBridges { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tempBridges):
                    self.bridges = tempBridges
                    
                    // сортировка полученных данных по ID
                    self.bridges.sort(by: { (bridgeOne, bridgeTwo) -> Bool in
                        if let first = bridgeOne.id, let second = bridgeTwo.id {
                            return first < second
                        } else { return false}
                    })
                    
                    self.tableView.reloadData()
                    self.showData()
                case .failure:
                    self.bridges = []
                    self.tableView.reloadData()
                    self.showError()
                }
            }
        }
    }
    
    func showData() {
        activityIndicator.stopAnimating()
        errorView.alpha = 0
    }
    
    func showError() {
        activityIndicator.stopAnimating()
        errorView.alpha = 1
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredBridges.count
        }
        return bridges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell") as! MainTableCell
        
        if !isFiltering {
            cell.setData(imageName: bridges[indexPath.row].previewImageURL ?? "None", title: bridges[indexPath.row].title ?? "None", shortText: bridges[indexPath.row].shortText ?? "None")
        }
        else {
            cell.setData(imageName: filteredBridges[indexPath.row].previewImageURL ?? "None",
                                    title: filteredBridges[indexPath.row].title ?? "None", shortText: filteredBridges[indexPath.row].shortText ?? "None")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bridgeViewController = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? BridgeViewController else { return }
        
        if !isFiltering {
            bridgeViewController.currentBridge = bridges[indexPath.row]
        }
        else {
            bridgeViewController.currentBridge = filteredBridges[indexPath.row]
        }
        
        // подсветка нажатой ячейки
        let cell = tableView.cellForRow(at: indexPath)
        cell?.lightningCell()
        
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
}



