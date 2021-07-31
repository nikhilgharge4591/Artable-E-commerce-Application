//
//  ViewController.swift
//  Artable
//
//  Created by Nikhil Gharge on 16/10/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logInOutBtn: UIBarButtonItem!
    
    var categoryArr = [Category]()
    var selectedCategory:Category!
    var db:Firestore!
    var listener:ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = Firestore.firestore()
        setUpCollextionView()
        setUpInitialAnonymousUser()
       
        //fetchCollections()
        //fetchDocument()
        //setCategoriesListener()
    }
    
    @IBAction func showFavourites(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavourites, sender: self)
    }
    func setUpCollextionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    func setUpInitialAnonymousUser(){
        if Auth.auth().currentUser == nil{
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error{
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.remove()
        categoryArr.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListener(){
        //call to the database
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (documentChange) in
                
                let data = documentChange.document.data()
                let category = Category(data: data)
                
                switch documentChange.type{
                case .added:
                    self.onDocumentAdded(documentChange: documentChange, category: category)
                case .modified:
                    self.onDocumentModified(documentChange:documentChange, category:category)
                case .removed:
                    self.onDocumentRemoved(documentChange:documentChange, category:category)
                }
                
            })
        })
    }
    
    func onDocumentAdded(documentChange:DocumentChange, category:Category){
        let index = Int(documentChange.newIndex)
        categoryArr.insert(category, at: index)
        collectionView.insertItems(at: [IndexPath(item: index, section:0)])
        
    }
    
    func onDocumentModified(documentChange:DocumentChange, category:Category){
        if documentChange.oldIndex == documentChange.newIndex{
            //if old index and new index are the same
            let oldIndex = Int(documentChange.oldIndex)
            collectionView.reloadItems(at: [IndexPath(item: oldIndex, section: 0)])
        }else{
            let oldIndex = Int(documentChange.oldIndex)
            let newIndex = Int(documentChange.newIndex)
            categoryArr.remove(at: oldIndex)
            categoryArr.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
        
    }
    
    func onDocumentRemoved(documentChange:DocumentChange, category:Category){
        let oldIndex = Int(documentChange.oldIndex)
        categoryArr.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section:0)])
        
    }
    
    func fetchDocument(){
        let docRef = Firestore.firestore().collection("categories").document("m545r2DTjGWNqtGvzYZ1")
        listener = docRef.addSnapshotListener { (snap, err) in
            self.categoryArr.removeAll()

            guard let data = snap?.data() else{return}
            let category = Category.init(data: data)
            self.categoryArr.append(category)
            self.collectionView.reloadData()
        }
//        docRef.getDocument { (snap, err) in
//            guard let data = snap?.data() else{
//                return
//            }
//
//            let category = Category.init(data: data)
//            self.categoryArr.append(category)
//            self.collectionView.reloadData()
//        }
    }
    
    func fetchCollections(){
        let collectionReference = Firestore.firestore().collection("categories")
        
      listener =  collectionReference.addSnapshotListener { (snap, err) in
        self.categoryArr.removeAll()
            guard let documents = snap?.documents else {return}
            for document in documents{
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categoryArr.append(newCategory)
            }
            self.collectionView.reloadData()
        }
//        collectionReference.getDocuments { (snap, err) in
//            guard let documents = snap?.documents else{return}
//            for document in documents{
//                let data =  document.data()
//                let newCategory = Category.init(data: data)
//                self.categoryArr.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
    }

    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: StoryBoard.LoginStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fetchCollections()
        setCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous{
            logInOutBtn.title = "Logout"
            if userService.userListener == nil{
                userService.getCurrentUser()
            }
        }else{
            logInOutBtn.title = "Login"
        }
   }
    
    
    @IBAction func logInOutBtnClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        if user.isAnonymous{
            presentLoginController()
        }else{
            do {
               try Auth.auth().signOut()
               userService.logout()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error{
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()

                }
            }catch{
                debugPrint(error)
            }
            
        }
        
//        if let _ = Auth.auth().currentUser{
//            //We are logged in
//            do{
//              //try Auth.auth().signOut()
//                presentLoginController()
//            }catch{
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//               debugPrint(error.localizedDescription)
//            }
//        }else{
//              presentLoginController()
//        }
//    }
   }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell{
            
            cell.configureCell(category: categoryArr[indexPath.item])
            
        return cell

        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoryArr[indexPath.row]
        performSegue(withIdentifier: "toProductVC", sender:self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = view.frame.width
        // bcoz we need to minus 20 , 20 and 10 from bothleft and right sides of collectionview
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductVC"{
            if let destination = segue.destination as? ProductsVC{
                destination.selectedCategory = selectedCategory
            }
        }else if segue.identifier == Segues.ToFavourites{
            if let destination = segue.destination as? ProductsVC{
                destination.selectedCategory = selectedCategory
                destination.showFavourites = true
            }
        }
    }
    
}
