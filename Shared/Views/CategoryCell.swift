//
//  CategoryCollectionViewCell.swift
//  Artable
//
//  Created by Nikhil Gharge on 17/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryImg.layer.cornerRadius = 5
    }
    
    func configureCell(category:Category){
          categoryName.text = category.name
        if let url = URL(string: category.imgUrl){
            let placeholder = UIImage(named: "placeholder")
            categoryImg.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
