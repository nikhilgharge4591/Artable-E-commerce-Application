//
//  UserService.swift
//  Artable
//
//  Created by Nikhil Gharge on 19/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let userService = _UserService()

final class _UserService{
    
    //variables
    var user = User()
    var favourites = [Product]()
    var auth = Auth.auth()
    var db = Firestore.firestore()
    
    var userListener: ListenerRegistration? = nil
    var favsListener: ListenerRegistration? = nil
    
    //Check whether it is guest or not
    var isGuest:Bool{
        
        guard let authUser = auth.currentUser else {
            return true
        }
        
        if authUser.isAnonymous{
            return true
        }else{
            return false
        }
    }
    
    func getCurrentUser(){
        
        //Check for current user
        guard let authUser = auth.currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(authUser.uid)
        
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else{return}
            self.user = User.init(data: data)
            print(self.user)
        })
        
        let favRef = userRef.collection("favourites")
        
        favRef.addSnapshotListener { (snap, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (document) in
                
                let favDoc = Product(data: document.data())
                self.favourites.append(favDoc)
            })
        }
        
    }
    
    func favouriteSelected(product:Product) {
        //First we will find out the reference
        let favRef = Firestore.firestore().collection("users").document(user.id).collection("favourites")
        
        if favourites.contains(product){
            //If it exists, then remove it.
            favourites.removeAll{$0 == product}
            favRef.document(product.id).delete()
        }else{
            
            //Add a new favourite product
            favourites.append(product)
            let data = Product.modelToData(prod: product)
            favRef.document(product.id).setData(data)
        }
    }
    
    func logout(){
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        favourites.removeAll()
        user = User()
    }
    
}
