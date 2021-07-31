//
//  User.swift
//  Artable
//
//  Created by Nikhil Gharge on 19/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

struct User {
    var id:String
    var email:String
    var username:String
    var stripeID:String
    
    init(id:String = "", email:String = "", username:String = "", stripeID:String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.stripeID = stripeID
    }
    
    init(data:[String:Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeID = data["stripeID"] as? String ?? ""
    }
    
    static func modelToData(user:User) -> [String:Any]{
        let data = ["id":user.id,
                    "email":user.email,
                    "username":user.username,
                    "stripeID":user.stripeID]
        return data
    }
}
