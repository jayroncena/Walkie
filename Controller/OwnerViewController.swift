//
//  OwnerViewController.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 1..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import UIKit
import MapKit

class OwnerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, WalkieController {
    
    

    @IBOutlet weak var myMap: MKMapView!
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?
 //   private var dogSitterLocation: CLLocationCoordinate2D?
 //   private var ownerLocation: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        if(category == "WALKIE_DOGSITTER"){
            WalkieHandler.Instance.delegate = self
            WalkieHandler.Instance.observerMessagesForDogsitter()
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
        WalkieRequest(title: "Walkie Request", message: "You have request for a Walkie at this location Lat: \(lat), Long: \(long)", requestAlive: true)
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
    
    
    
    @IBAction func callDogSitter(_ sender: Any) {
        WalkieHandler.Instance.requestWalkie(latitude: Double(userLocation!.latitude), longtitude: Double(userLocation!.longitude))
    }
    
    private func WalkieRequest(title: String, message: String, requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if requestAlive{
            let accept = UIAlertAction(title: "Accept", style: .default, handler: {
                (alertAction: UIAlertAction) in
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
    
    /*
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
    */
    
    
    
    
    
    

}// class
