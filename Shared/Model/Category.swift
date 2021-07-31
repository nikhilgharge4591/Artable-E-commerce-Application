//
//  Category.swift
//  Artable
//
//  Created by Nikhil Gharge on 17/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name:String
    var id:String
    var imgUrl:String
    var isActive:Bool = true
    var timestamp:Timestamp
    
    init(name:String, id:String, imgUrl:String, isActive:Bool, timestamp:Timestamp){
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
        self.isActive = isActive
        self.timestamp = timestamp
    }
    
    init(data:[String:Any]) {

        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        
    }
    
    static func modelToData(category:Category) -> [String:Any]{
        let newCategoryDict: [String : Any] = ["name":category.name,
                               "id":category.id,
                               "imgUrl":category.imgUrl,
                               "isActive":category.imgUrl,
                               "timestamp":category.timestamp]
        return newCategoryDict
    }
    
}
