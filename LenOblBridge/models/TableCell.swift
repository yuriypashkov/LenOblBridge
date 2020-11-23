import UIKit
import Kingfisher

class TableCell: UITableViewCell {
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(imageName: String, title: String) {
        if let url = URL(string: imageName) {
            mainImage.kf.indicatorType = .activity
            mainImage.kf.setImage(with: url)
        }
        mainImage.layer.cornerRadius = 5.0
        titleLabel.text = title
    }

}

