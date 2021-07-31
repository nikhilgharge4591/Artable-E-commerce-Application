//
//  AdminProductVC.swift
//  ArtableAdmin
//
//  Created by Nikhil Gharge on 08/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit

class AdminProductVC: ProductsVC {

    var selectedProduct:Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        
        let newProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: false)
    }
    
    @objc func editCategory(){
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    
    @objc func newProduct(){
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAddEditProduct {
            if let destinationVC = segue.destination as? AddEditProductsVC{
                destinationVC.selectedCategory = selectedCategory
                destinationVC.productToEdit = selectedProduct
            }
        }else if segue.identifier == Segues.toEditCategory{
            if let destinationVC = segue.destination as? AddEditCategoryVC{
                destinationVC.selectedCategory = selectedCategory
            }
        }
    }
    
    
}
