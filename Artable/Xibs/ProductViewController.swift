//
//  ProductViewController.swift
//  Artable
//
//  Created by Nikhil Gharge on 06/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product:Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let product = product{
            print(product.name)
            productTitle.text = product.name
            productDescription.text = product.productDescription
            
            if let url = URL(string: product.imageURL){
                productImage.kf.setImage(with: url)
            }
            
            // Available currency formatter dependeing upon various country
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            if let price = formatter.string(from: product.price as NSNumber ){
                productPrice.text = price
            }
        }else{
            print("Product details not found")
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addKartClicked(_ sender: Any) {
        // Add product to cart
        guard let product = product else {
            return
        }
        StripCart.addItemsToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
