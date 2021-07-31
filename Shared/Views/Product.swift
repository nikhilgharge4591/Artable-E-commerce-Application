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
    var price:Double
    var productDescription:String
    var imageURL:String
    var timestamp:Timestamp
    var stock:Int
}
