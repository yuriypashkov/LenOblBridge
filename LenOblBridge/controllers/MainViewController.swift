
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var bridges = BridgesBank()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://localhost:3000/bridges"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                let parsedResult: [Bridge] = try JSONDecoder().decode([Bridge].self, from: data!)
                print(parsedResult)
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
        return bridges.bridgesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setData(imageName: bridges.bridgesArray[indexPath.row].imagePreviewName, title: bridges.bridgesArray[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bridgeViewController = storyboard.instantiateViewController(identifier: "TestViewController") as? BridgeViewController else { return }
        bridgeViewController.currentBridge = bridges.bridgesArray[indexPath.row]
        navigationController?.pushViewController(bridgeViewController, animated: true)
    }
}

