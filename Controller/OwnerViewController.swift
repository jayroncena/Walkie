//
//  OwnerViewController.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 1..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import UIKit
import MapKit

class OwnerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, WalkieController, WalkieOwnerController {
    
    

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var callWalkieBtn: UIButton!
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?
 //   private var dogSitterLocation: CLLocationCoordinate2D?
 //   private var ownerLocation: CLLocationCoordinate2D?
    
    //For the owner
    private var canCallWalkie = true
    private var ownerCancelRequest = false
    
    //For the dogSitter
    private var acceptedWalkie = false
    private var dogSitterCanceledWalkie = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        WalkieHandler.Instance.observeMessagesForOwner()
        if(category == "WALKIE_DOGSITTER"){
            callWalkieBtn.setTitle("Cancel Walkie", for: UIControlState.normal)
            WalkieHandler.Instance.delegate = self
            WalkieHandler.Instance.observerMessagesForDogsitter()
        }
        if(category == "WALKIE_OWNER"){
            callWalkieBtn.isHidden = false
            WalkieHandler.Instance.delegateOwner = self
        }

        // Do any additional setup after loading the view.
    }
    
    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate{
           
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            
            let region = MKCoordinateRegionMake(userLocation!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
            myMap.removeAnnotations(myMap.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            
            if(category == "WALKIE_OWNER"){
                annotation.title = "Owner Location"
            }
            else{
                 annotation.title = "DogSitter Location"
            }
            myMap.addAnnotation(annotation)
        }
        
        
    }
    
    func acceptWalkie(lat: Double, long: Double) {
        if !acceptedWalkie{
            WalkieRequest(title: "Walkie Request", message: "You have request for a Walkie at this location Lat: \(lat), Long: \(long)", requestAlive: true)
        }
    }

    func ownerCancelledWalkie() {
        if !dogSitterCanceledWalkie{
            WalkieHandler.Instance.cancelWalkieForDogSitter()
            self.acceptedWalkie = false;
            self.callWalkieBtn.isHidden = true
            WalkieRequest(title: "Walkie Canceled", message: "The owner has canceled the walkie", requestAlive: false)
        }
    }
    
    func walkieCanceled() {
        acceptedWalkie = false
        callWalkieBtn.isHidden = true
        // invalidate the timer
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            dismiss(animated: true, completion: nil)
        }else{
            //problem with signing out
            WalkieRequest(title: "Could Not Logout", message: "We could not logout at the moment please try again later", requestAlive: false)
           // alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment please try again later")
        }
    }
    
    //for owner
    func canCallWalkie(delegateCalled: Bool) {
        if delegateCalled{
            callWalkieBtn.setTitle("Cancel Walkie", for: UIControlState.normal)
            canCallWalkie = false
        }else{
            callWalkieBtn.setTitle("Call Dog Sitter", for: UIControlState.normal)
            canCallWalkie = true
        }
    }
    
    func dogSitterAcceptedRequest(requestAccepted: Bool, dogSitterName: String) {
        if !ownerCancelRequest{
            if requestAccepted{
                alertTheUser(title: "Walkie Accepted", message: "\(dogSitterName) Accepted your walkie Request")
            }else{
                WalkieHandler.Instance.cancelWalkie()
                alertTheUser(title: "Walkie Canceled", message: "\(dogSitterName) canceled your walkie Request")
            }
        }
    }
    
    @IBAction func callDogSitter(_ sender: Any) {
        
        
        if(category == "WALKIE_OWNER")
        {
            //WalkieHandler.Instance.requestWalkie(latitude: Double(userLocation!.latitude), longtitude: Double(userLocation!.longitude))
            if userLocation != nil{
                if canCallWalkie{
                    WalkieHandler.Instance.requestWalkie(latitude: Double(userLocation!.latitude), longtitude: Double(userLocation!.longitude))
                }else{
                    ownerCancelRequest = true
                    WalkieHandler.Instance.cancelWalkie()            }
            }
        }else{
            if acceptedWalkie{
                dogSitterCanceledWalkie = true
                callWalkieBtn.isHidden = true
                WalkieHandler.Instance.cancelWalkieForDogSitter()
                
                //invalidate timer
            }
        }
    }
    
    private func WalkieRequest(title: String, message: String, requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if requestAlive{
            let accept = UIAlertAction(title: "Accept", style: .default, handler: {
                (alertAction: UIAlertAction) in
                
                self.acceptedWalkie = true
                self.callWalkieBtn.isHidden = false
                
                // inform that we accepted the Walkie
                WalkieHandler.Instance.walkieAccepted(lat: Double(self.userLocation!.latitude), long: Double(self.userLocation!.longitude))
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(accept)
            alert.addAction(cancel)
        }else{
             let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
 
    
    
    
    
    
    

}// class
