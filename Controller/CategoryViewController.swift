//
//  CategoryViewController.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 5..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import UIKit

var category = ""

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func categoryIsOwner(_ sender: Any) {
        category = "WALKIE_OWNER"
    }
    
    @IBAction func categoryIsDogsitter(_ sender: Any) {
        category = "WALKIE_DOGSITTER"
    }
}
