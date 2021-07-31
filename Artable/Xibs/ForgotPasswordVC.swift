//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Nikhil Gharge on 15/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        if let email = emailTxtField.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error{
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error.localizedDescription)
                }
               self.dismiss(animated: true, completion: nil)
            }
        }else{
            return
        }
        
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
