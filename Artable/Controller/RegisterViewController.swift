//
//  RegisterViewController.swift
//  Artable
//
//  Created by Nikhil Gharge on 13/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var confirmPasswordCheckImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        confirmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    

     @objc func textFieldDidChange(_ textfield:UITextField){
        
        guard let passTxt = passwordTxt.text else {
            return
        }
        
        
        if textfield == confirmPasswordTxt{
            passwordCheckImg.isHidden = false
            confirmPasswordCheckImg.isHidden = false
        }else{
            if passTxt.isEmpty{
            passwordCheckImg.isHidden = true
            confirmPasswordCheckImg.isHidden = true
            confirmPasswordTxt.text = ""
            }
        }
        //Make it so when passwords match , the checkmarks turn green
        if passwordTxt.text == confirmPasswordTxt.text{
            passwordCheckImg.image = UIImage(named: "green_check")
            confirmPasswordCheckImg.image  = UIImage(named: "green_check")
        }else{
            passwordCheckImg.image = UIImage(named: "red_check")
            confirmPasswordCheckImg.image  = UIImage(named: "red_check")
        }
    }
    @IBAction func registerClicked(_ sender: Any) {
        
        //check for empty details
        guard let email = emailTxt.text, email.isNotEmpty, let username = usernameTxt.text, username.isNotEmpty, let password = passwordTxt.text, password.isNotEmpty else{
            simpleAlert(title: "Error", msg: "Please check details in all the fields")
            return}
        
        
        //Password matching alert
        guard let confirmPass = confirmPasswordTxt.text, confirmPass == password else {
            simpleAlert(title: "Error", msg: "Passwords do not match")
            return
        }
        activityIndicator.startAnimating()
        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error{
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//                debugPrint(error)
//                return
//            }
//
//            guard let firUser = result?.user else {return}
//
//            let artUser = User(id: firUser.uid, email: email, username: username, stripeID: "")
//
//            self.uploadNewUser(user: artUser)
//
//        }
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }

        let credentials = EmailAuthProvider.credential(withEmail: email, password:password)
        authUser.link(with: credentials) { (result, error) in

            if let error = error{
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
                return
            }
            
            guard let firUser = result?.user else {return}
            
            let artUser = User(id: firUser.uid, email: email, username: username, stripeID: "")
            
            self.uploadNewUser(user: artUser)
        }
        
        
    }
    
    func uploadNewUser(user:User){
        
        //Step 1: Create document reference
        let userRef = Firestore.firestore().collection("users").document(user.id)
        
        //Step 2: ModelToData
        let modelData = User.modelToData(user: user)
        
        //Upload to firestore
        userRef.setData(modelData) { (error) in
            if let error = error{
               Auth.auth().handleFireAuthError(error: error, vc: self)
               debugPrint("Unable to upload document")
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()

        }
        
        
    }
    

}
