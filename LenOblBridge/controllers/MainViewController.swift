
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var parsedBridges = [Bridge]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        
        let urlString = "https://5daad02998ba.ngrok.io/bridges"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                self.parsedBridges = try JSONDecoder().decode([Bridge].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedBridges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setData(imageName: parsedBridges[indexPath.row].previewImageURL ?? "None",
                     title: parsedBridges[indexPath.row].title ?? "None")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bridgeViewController = storyboard.instantiateViewController(identifier: "TestViewController") as? BridgeViewController else { return }
        bridgeViewController.currentBridge = parsedBridges[indexPath.row]
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
}



