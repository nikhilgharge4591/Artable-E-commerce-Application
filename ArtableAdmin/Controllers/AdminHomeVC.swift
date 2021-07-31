//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by Nikhil Gharge on 16/10/19.
//  Copyright © 2019 Nikhil Gharge. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryBarButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action:#selector(addCategory))
        
        navigationItem.rightBarButtonItem = addCategoryBarButton
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @objc func addCategory(){
        performSegue(withIdentifier: "ToAddEditCategory", sender: self)
    }
    
    


}

