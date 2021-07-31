//
//  StripeApi.swift
//  Artable
//
//  Created by Nikhil Gharge on 05/02/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        print(apiVersion)
        let data = ["stripe_version":apiVersion,
                    "customer_id":userService.user.stripeID]
        print(userService.user.stripeID)
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, err) in
            print(result?.data)
            
            if let error = err{
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let key  = result?.data as? [String:Any] else {
                completion(nil, nil)
                return
            }
            completion(key, nil)
                
        }
    }
}
