import UIKit

class TableCell: UITableViewCell {
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(imageName: String, title: String) {
        mainImage.image = UIImage(named: "tempImage")
        mainImage.lazyImageDownload(url: imageName)
        titleLabel.text = title
    }

}
