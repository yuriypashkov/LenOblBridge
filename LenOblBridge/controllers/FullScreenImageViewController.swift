

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageUrl: String?
    var imageToShow: UIImage?
    var tabBar: CustomTabController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = tabBarController as? CustomTabController
        navigationController?.hidesBarsOnTap = true
        if let image = imageToShow { imageView.image = image }
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar?.tabBar.alpha = 0
        tabBar?.containerView.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBar?.tabBar.alpha = 1
        tabBar?.containerView.alpha = 1
    }

}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
