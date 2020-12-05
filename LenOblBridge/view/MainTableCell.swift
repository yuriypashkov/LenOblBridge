//
//  TestTableCell.swift
//  LenOblBridge
//
//  Created by Yuriy Pashkov on 11/23/20.
//  Copyright © 2020 Yuriy Pashkov. All rights reserved.
//
import Kingfisher
import UIKit

class MainTableCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortTextLabel: UILabel!
    
    func setData(imageName: String, title: String, shortText: String) {
        if let url = URL(string: imageName) {
            mainImage.kf.indicatorType = .activity
            mainImage.kf.setImage(with: url)
        }
        
        mainImage.layer.cornerRadius = 45.0
        coverView.layer.cornerRadius = coverView.frame.width / 2
        titleLabel.text = title
        shortTextLabel.text = shortText
        //mainImage.layer.borderWidth = 5
       // mainImage.layer.borderColor = UIColor.yellow.cgColor
        // set gradient
        //let gradientImage = CAGradientLayer.primaryGradient(on: self.contentView)
        //self.backgroundColor = UIColor(patternImage: gradientImage!)
    }
    
}

extension UITableViewCell {
    
    func lightningCell() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 0.70)
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                if #available(iOS 13.0, *) {
                    self.contentView.backgroundColor = .secondarySystemBackground
                } else {
                    self.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
                }
            }
        }
    }
    
}

