//
//  CheckoutVC.swift
//  Artable
//
//  Created by Nikhil Gharge on 31/01/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutVC: UIViewController, removeProductFromCart {
 
    //Outlets
    
    @IBOutlet weak var cartTableview: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var shippingLbl: UILabel!
    
    //Variable's
    var paymentContext: STPPaymentContext!
    var paymentStatus: STPPaymentStatus!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpCartTableView()
        setUpPaymentInfo()
        setupStripeConfig()
    }
    
    func setUpCartTableView(){
        
        cartTableview.dataSource = self
        cartTableview.delegate = self
        cartTableview.register(UINib(nibName: Identifiers.cartCell, bundle: nil), forCellReuseIdentifier: Identifiers.cartCell)
    }
    
    func setUpPaymentInfo(){
        
        subtotalLbl.text = StripCart.subtotal.penniesToString()
        processingFeeLbl.text = StripCart.processingFees.penniesToString()
        shippingLbl.text = StripCart.shippingfees.penniesToString()
        totalLbl.text = StripCart.total.penniesToString()
    }
    
    func productRemovedFromCart(product: Product) {
        StripCart.removeItemsFromCart(item: product)
        cartTableview.reloadData()
        setUpPaymentInfo()
        paymentContext.paymentAmount = StripCart.total
    }
    
    func setupStripeConfig(){
        
        let config = STPPaymentConfiguration.shared()
        //config.createCardSources = true
        config.requiredBillingAddressFields = .full
        config.requiredShippingAddressFields = [.postalAddress]
        
        
       let customerContext = STPCustomerContext(keyProvider: StripeApi)
       paymentContext = STPPaymentContext(customerContext:customerContext, configuration: config, theme: .default())
       paymentContext.paymentAmount = StripCart.total
       paymentContext.delegate = self
       paymentContext.hostViewController = self
        
    }
    

    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripCart.cartitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cartCell, for: indexPath) as? CartTableCell{
            
            let product = StripCart.cartitems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension CheckoutVC: STPPaymentContextDelegate{
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
             let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
             
             let data:[String:Any] = [
                 "total":StripCart.total,
                 "customerId":userService.user.stripeID,
                 "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
                 "idempotency":idempotency]
             
             Functions.functions().httpsCallable("makeCharge").call(data) { (result, err) in
                 
                 if let err = err{
                     debugPrint(err.localizedDescription)
                     self.simpleAlert(title: "Error", msg: "Unable to make charge")
                     completion(STPPaymentStatus.error, err)
                     return
                 }
                 
                 StripCart.clearCart()
                 self.cartTableview.reloadData()
                 self.setUpPaymentInfo()
                 completion(STPPaymentStatus.success, err)

                 
             }
        
    }
    
    
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        //Updating the payment select method
        
        if let payment = paymentContext.selectedPaymentOption{
            paymentMethodBtn.setTitle(payment.label, for: .normal)
        }else{
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
            
        //Updating the shipping address
        
        if let shipping = paymentContext.selectedShippingMethod{
            shippingMethodBtn.setTitle(shipping.label, for: .normal)
        }else{
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }

        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        //If the customer is not an valid stripe user
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title:String
        let message:String
        
        paymentStatus = status
        
        switch status {
        case .error:
            activityIndicator.stopAnimating()
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            activityIndicator.stopAnimating()
            title = "Success"
            message = "Thank you for the purchase"
        case .userCancellation:
            return
            
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
            
        //shipping methods
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives Tommorow"
        fedEx.identifier = "fedex"
        
        
        if address.country == "IE"{
            completion(.valid, nil, [upsGround, fedEx], fedEx)
        }else{
            completion(.invalid, nil, nil, nil)
        }
    }
    
    
    
}
