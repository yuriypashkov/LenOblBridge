
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
    
    
    let bridgesModel = BridgesModel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        bridgesModel.delegate = self
        
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
        guard let count = bridgesModel.parsedBridges else { return 0}
        //return bridgesModel.parsedBridges.count
        return count.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setData(imageName: bridgesModel.parsedBridges?[indexPath.row].previewImageURL ?? "None",
                     title: bridgesModel.parsedBridges?[indexPath.row].title ?? "None")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bridgeViewController = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? BridgeViewController else { return }
        bridgeViewController.currentBridge = bridgesModel.parsedBridges?[indexPath.row]
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
}



