//
//  AddEditCategory.swift
//  ArtableAdmin
//
//  Created by Nikhil Gharge on 06/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var categoryNameTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryImg: RoundedImageView!
    
    @IBOutlet weak var editCategoryButton: RoundedButton!
    
    var selectedCategory:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectandInsertImage))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        
        if let editCategoryName = selectedCategory{
            categoryNameTxt.text = editCategoryName.name
            
            if let img = URL(string: editCategoryName.imgUrl){
                categoryImg.kf.setImage(with: img)
            }
        }
    }
    
    @objc func selectandInsertImage(){
        launchImage()
    }
    

    @IBAction func addCategoryClicked(_ sender: Any) {
        uploadImageInCloudStorage()
    }

    func uploadImageInCloudStorage(){
        
        guard let image = categoryImg.image, let categoryName = categoryNameTxt.text, categoryName.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Must add category image and name")
            return
        }
        
        activityIndicator.startAnimating()
        //Step 1: Turn the image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        //Step 2:Create storage image reference -> A location in Firestorage for it to be stored
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        //Step 3: Create a metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //Step 4 Upload the data
        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            
            
            if let error = error {
                debugPrint(error)
                self.simpleAlert(title: "Error", msg:"Unable to upload the image")
                self.activityIndicator.stopAnimating()
                return
            }
            
            //Step 5: Once the image is uploaded , retireve th url
            
            imageRef.downloadURL(completion: { (url, err) in
                
                if let error = err{
                    debugPrint(error.localizedDescription)
                    self.simpleAlert(title: "Error", msg: "Unable to download the image")
                    self.activityIndicator.startAnimating()
                    return
                }
                
                guard let url = url else{
                       return}
                print(url)
                //Step 6: Upload the new cateory document to the firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url:String){
        let docRef:DocumentReference!
        var category = Category(name: categoryNameTxt.text!,
                                id:"",
                                imgUrl:url,
                                isActive:true,
                                timestamp:Timestamp())
       
        if let categoryToEdit = selectedCategory{
          
            //Old Category
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = docRef.documentID
        }else{
            
            //New Category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        
        let newCategoryDict = Category.modelToData(category: category)
        
        docRef.setData(newCategoryDict, merge: true) { (error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg:"Unable to upload document")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension AddEditCategoryVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func launchImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
