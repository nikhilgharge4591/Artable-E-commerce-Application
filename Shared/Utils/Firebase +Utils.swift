//
//  Firebase +Utils.swift
//  Artable
//
//  Created by Nikhil Gharge on 17/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import Firebase
import UIKit
import Foundation

extension Firestore{
    var categories:Query{
        return collection("categories").order(by: "timestamp", descending:true)
    }
    var products:Query{
        return collection("products").order(by: "timestamp", descending: true)
    }
}

extension Auth{
    func handleFireAuthError(error:Error, vc:UIViewController){
        if let errorcode = AuthErrorCode(rawValue: error._code){
            let alert = UIAlertController(title: "Error", message: errorcode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion:nil)
        }
        
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
    
}


