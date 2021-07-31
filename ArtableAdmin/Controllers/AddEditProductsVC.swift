//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by Nikhil Gharge on 08/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore


class AddEditProductsVC: UIViewController {

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptiontTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var productToEdit: Product?
    var newProduct:Product?
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedCategory?.name)
        print(productToEdit?.name)
        if let prodToEdit = productToEdit, let selCategory = selectedCategory{
            print(selectedCategory?.name)
        }else{
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectProductImage))
        tap.numberOfTapsRequired = 1
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tap)
    }
    
    @objc func selectProductImage(){
        launchPicker()
    }
    
    @IBAction func addProduct(_ sender: Any) {
        uploadImageInCloudStorage()
    }
   

    func uploadImageInCloudStorage(){
        
        guard let prodName = productNameTextField.text, prodName.isNotEmpty, let prodPrice = productPriceTextField.text, let finalPrice = Double(prodPrice),let prodDesc = productDescriptiontTextView.text,prodDesc.isNotEmpty, let image = productImageView.image else {
            simpleAlert(title: "Error", msg: "Unable to upload image")
            return
        }
        
        activityIndicator.startAnimating()
        //Step 1: Turn the image into data
        guard let img = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        //Create an image reference -> A location in Firestore for it to be stored
        let productImageRef = Storage.storage().reference().child("/productImages/\(prodName).jpg")
        
        //Step 3: Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //Step 4: Upload the data
        productImageRef.putData(img, metadata: metadata) { (metadata, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "Unable to upload data")
                self.activityIndicator.stopAnimating()
                return
            }
            
            productImageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.simpleAlert(title: "Error", msg: "Unable to download the url")
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                guard let url = url else{
                    return}
                print(url)
                //Step 6: Upload the new product document to the firestore categories collection
                self.uploadNewProductDocument(url:url.absoluteString)
            })

        }
        
    }
    
    func uploadNewProductDocument(url:String){
        let docRef:DocumentReference!
        
        if productToEdit == nil{
            if let selCategory = selectedCategory?.id, let prodName = productNameTextField.text, let priceProd = productPriceTextField.text, let prodDesc = productDescriptiontTextView.text{
                var product = Product(name: prodName, id: "", category:selCategory, price: Double(priceProd)!, productDescription: prodDesc, imageURL:"", timestamp: Timestamp(), stock:10)
                newProduct = product
            }

        }
        
        if let prodName = productNameTextField.text, prodName.isNotEmpty, let selCategory = selectedCategory?.id, selCategory.isNotEmpty, let productToEditDetails = productToEdit ?? newProduct{
            var product = Product(name: prodName, id: "", category: selCategory, price: productToEditDetails.price, productDescription: productToEditDetails.productDescription, imageURL: url, timestamp: productToEditDetails.timestamp, stock:10)

            if let prodToEdit = productToEdit{
                //old product
                docRef = Firestore.firestore().collection("products").document(prodToEdit.id)
                product.id = prodToEdit.id
            }else{
                
                //New product
                docRef = Firestore.firestore().collection("products").document()
                guard let newProd = newProduct else{
                    return
                }
                product.id = newProd.id
            }
            
            let prodDataDict = Product.modelToData(prod: product)
            
                docRef.setData(prodDataDict, merge: true) { (error) in
                    if let error = error{
                        debugPrint(error.localizedDescription)
                        self.simpleAlert(title: "Error", msg:"Unable to upload document")
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func launchPicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        productImageView.contentMode = .scaleToFill
        productImageView.image = image
        dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
