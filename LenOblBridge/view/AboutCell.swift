
import UIKit

class AboutCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    func setCell(imageName: String, title: String, about: String) {
        mainImage.image = UIImage(named: imageName)
        titleLabel.text = title
        aboutLabel.text = about
    }
    

}
