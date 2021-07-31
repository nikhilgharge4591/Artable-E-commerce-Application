//
//  ProductsVC.swift
//  Artable
//
//  Created by Nikhil Gharge on 29/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ProductsVC: UIViewController, ProductCellDelegate {
    //Outlets
    
    @IBOutlet weak var productsTableView: UITableView!
    
    var products = [Product]()
    var selectedCategory:Category!
    var listener:ListenerRegistration!
    var db:Firestore!
    
    var showFavourites:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        print(selectedCategory)
      /*
        let product = Product.init(name: "Landscape", id: "hkjhgatsrw",category:"Landscapes", price: 24.99, productDescription: "what a lovely landscape", imageURL:"https://images.unsplash.com/photo-1506260408121-e353d10b87c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=900&q=60", timestamp: Timestamp(), stock: 0)
        
        products.append(product)
        */
        setUptableViewAndRegisterNib()
        //fetchProducts()
        // first time all the products will be present in product list.
        setProductListener()
        // Do any additional setup after loading the view.
    }
    
    func setUptableViewAndRegisterNib(){
        
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier:Identifiers.ProductCell)

    }
    
    func productfavourited(product: Product) {
        //Call
        userService.favouriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else {
            return
        }
        productsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func addProductToCart(product: Product) {
        StripCart.addItemsToCart(item: product)
    }
    
    func fetchProducts(){
        let productReference = Firestore.firestore().collection("products")
        
        listener = db.products.addSnapshotListener({ (snap, err) in
            self.products.removeAll()
            if let error = err {
                debugPrint(error.localizedDescription)
            }
            
            guard let documents = snap?.documents else {return}
            for doc in documents{
                let data = doc.data()
                let product = Product(data: data)
                self.products.append(product)
            }
            self.productsTableView.reloadData()
        })
    }
    
    func setProductListener(){
        
        //To show favourites or not.
        var ref:Query!
        
        if showFavourites{
            ref = db.collection("users").document(userService.user.id).collection("favourites")
        }else{
            ref = db.products.whereField("category", isEqualTo: selectedCategory.id)
        }
        
        
        listener = db.products.whereField("category", isEqualTo: selectedCategory.id).addSnapshotListener({ (snap, err) in
            
            if let error = err{
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (DocumentChange) in
                
                let data = DocumentChange.document.data()
                let product = Product(data: data)
                
                switch DocumentChange.type{
                case .added:
                    self.onDocumentAdded(documentChange:DocumentChange, category:product)
                case .modified:
                    self.onDocumentModified(documentChange:DocumentChange, category:product)
                case .removed:
                    self.onDocumnetRemoved(documentChange:DocumentChange, category:product)
                    
                }
                
            })
            
        })
    }
    
    func onDocumentAdded(documentChange:DocumentChange, category:Product){
        
        let newIndex = Int(documentChange.newIndex)
        products.insert(category, at: newIndex)
        productsTableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        
    }
    
    func onDocumentModified(documentChange:DocumentChange, category:Product){
        
        
        if documentChange.oldIndex == documentChange.newIndex{
            // old index and new index are same
            let index = Int(documentChange.oldIndex)
            products[index] = category
            productsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }else{
            // old index and new index are not same
            let oldIndex = Int(documentChange.oldIndex)
            let newIndex = Int(documentChange.newIndex)
            products.remove(at: oldIndex)
            products.insert(category, at: newIndex)
            productsTableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumnetRemoved(documentChange:DocumentChange, category:Product){
        let oldIndex = Int(documentChange.oldIndex)
        products.remove(at: oldIndex)
        productsTableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: UITableView.RowAnimation.none)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductsVC:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productVC = ProductViewController()
        let selectedProduct = products[indexPath.row]
        productVC.product = selectedProduct
        productVC.modalTransitionStyle = .crossDissolve
        productVC.modalPresentationStyle = .overCurrentContext
        present(productVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell{
            
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
        
    }
    
  

}

