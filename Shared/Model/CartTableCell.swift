//
//  CartTableCell.swift
//  Artable
//
//  Created by Nikhil Gharge on 31/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit

protocol removeProductFromCart:class {
    func productRemovedFromCart(product:Product)
}

class CartTableCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    weak var delegate:removeProductFromCart!
    
    private var product:Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product:Product, delegate:removeProductFromCart){
        
        self.product = product
        self.delegate = delegate
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber){
            productTitleLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string:product.imageURL){
            productImage.kf.setImage(with: url)
        }
        
    }
    
    
    
    @IBAction func removeItemBtnClicked(_ sender: Any) {
        delegate.productRemovedFromCart(product: product)
    }
    
}
