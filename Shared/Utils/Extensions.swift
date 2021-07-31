//
//  File.swift
//  Artable
//
//  Created by Nikhil Gharge on 13/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String{
    var isNotEmpty: Bool{
        return !isEmpty
    }
}
 
extension UIViewController {

    
    func simpleAlert(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension Int{
    
    func penniesToString() -> String {
        
        // If we have passed 1234 then dollars would be $12.34 i.e 1234/100
        let dollarsAmount = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarAmt = formatter.string(from: dollarsAmount as NSNumber){
            return dollarAmt
        }
        
        return "$0.00"
        
    }
}



