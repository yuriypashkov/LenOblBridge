import UIKit

class TableCell: UITableViewCell {
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(imageName: String, title: String) {
//        mainImage.image = UIImage(named: "tempImage")
//        mainImage.lazyImageDownload(url: imageName)
        if let url = URL(string: imageName) {
            //mainImage.loadImageWithUrl(url: url)

            let yourImageView: ImageLoader = {
                let iv = ImageLoader()
                iv.frame = mainImage.frame
                iv.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                return iv
            }()
            addSubview(yourImageView)
            yourImageView.newLoadImageWithUrl(url: url)
            
        }
        titleLabel.text = title
    }

}
