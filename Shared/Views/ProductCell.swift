//
//  ProductCell.swift
//  Artable
//
//  Created by Nikhil Gharge on 29/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate:class {
    func productfavourited(product:Product)
    func addProductToCart(product:Product)

}


class ProductCell: UITableViewCell {

    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var favouriteBtn: UIButton!
    weak var delegate:ProductCellDelegate!
    
    private var product:Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product:Product, delegate:ProductCellDelegate){
        
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber){
            productPrice.text = "\(price)"
        }
        
        if let img = URL(string: product.imageURL){
            productImg.kf.setImage(with: img)
        }
        
        //Check if it contains in our favourite
        if userService.favourites.contains(product){
            //change image
            favouriteBtn.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        }else{
            favouriteBtn.setImage(UIImage(named:AppImages.EmptyStar), for:.normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        self.delegate.addProductToCart(product: product)
     }
    
    
    @IBAction func favouriteClicked(_ sender: Any) {
        delegate.productfavourited(product: product)
    }
}
