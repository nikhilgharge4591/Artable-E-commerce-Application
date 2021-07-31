//
//  LoginViewController.swift
//  Artable
//
//  Created by Nikhil Gharge on 13/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        
        let modalViewController = ForgotPasswordVC()
        modalViewController.modalTransitionStyle = .crossDissolve
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty, let password = passwordTxt.text, password.isNotEmpty else {
            simpleAlert(title: "Error", msg:"Please fill all the fields")
            return
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (authResultErr, error) in
            
            if let err = error{
                Auth.auth().handleFireAuthError(error: err, vc: self)
                debugPrint(err)
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func guestButtonClicked(_ sender: Any) {
        
    }
    
}
