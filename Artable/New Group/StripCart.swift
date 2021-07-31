//
//  StripCart.swift
//  Artable
//
//  Created by Nikhil Gharge on 31/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

let StripCart = _stripeCart()

final class _stripeCart{
    
    
    var cartitems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatfeecents = 30
    var shippingfees = 0
    
    //variables for total, processing fees and shipping details
    var subtotal:Int{
        var amount = 0
        for item in cartitems{
            amount += Int(item.price * 100)
        }
        return amount
    }
    
    var processingFees:Int{
        
        if subtotal == 0{
            return 0
        }
        
        let sub = Double(subtotal)
        let feesandsub = Int(sub * stripeCreditCardCut) + flatfeecents
        return feesandsub
    }
    
    var total:Int{
        return subtotal + processingFees + shippingfees
    }
    
    func addItemsToCart(item:Product){
        cartitems.append(item)
    }
    
    func removeItemsFromCart(item:Product){
        if let index = cartitems.firstIndex(of: item){
            cartitems.remove(at: index)
        }
    }
    
    func clearCart(){
        cartitems.removeAll()
    }
}
