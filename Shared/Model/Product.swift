//
//  Product.swift
//  Artable
//
//  Created by Nikhil Gharge on 29/11/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name:String
    var id:String
    var category:String
    var price:Double
    var productDescription:String
    var imageURL:String
    var timestamp:Timestamp
    var stock:Int
    
    init(name:String, id:String, category:String, price:Double, productDescription:String, imageURL:String, timestamp:Timestamp, stock:Int){
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageURL = imageURL
        self.timestamp = timestamp as? Timestamp ?? Timestamp()
        self.stock = stock
    }
    
    init(data:[String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageURL = data["imgUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    static func modelToData(prod:Product) -> [String:Any]{
        
        let dictData:[String:Any] = ["name": prod.name, "id": prod.id, "category":prod.category, "price":prod.price, "productDescription": prod.productDescription, "imageURL":prod.imageURL, "timestamp":prod.timestamp, "stock":prod.stock]
        
        return dictData
        
    }
    
    
}

extension Product:Equatable{
    
    static func ==(lhs: Product, rhs:Product) -> Bool{
        return lhs.id == rhs.id
    }
}
