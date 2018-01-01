//
//  OwnerViewController.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 1..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import UIKit
import MapKit

class OwnerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            dismiss(animated: true, completion: nil)
        }else{
            //problem with signing out
            alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment please try again later")
        }
    }
    
    
    
    @IBAction func callDogSitter(_ sender: Any) {
    }
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
    
    
    
    
    
    
    

}// class
