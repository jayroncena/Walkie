//
//  WalkeHandler.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 5..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol WalkieController: class{
    func acceptWalkie(lat: Double, long: Double)
}

class WalkieHandler{
    

    
    private static let _instance = WalkieHandler()
    weak var delegate: WalkieController?
    
    var owner = ""
    var dogSitter = ""
    var owner_id = ""
    var dogSitter_id = ""
    
    static var Instance: WalkieHandler{
        return _instance
    }
    
    func requestWalkie(latitude: Double, longtitude: Double){
        let data : Dictionary<String, Any> = [Constants.NAME: owner, Constants.LATITUDE: latitude,Constants.LONGITUDE: longtitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }//request Walkie
    
    func observerMessagesForDogsitter(){
        //owner requested a Walkie
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                if let latitude = data[Constants.LATITUDE] as? Double{
                    if let longitude = data[Constants.LONGITUDE] as? Double{
                        //inform the owner VC
                        self.delegate?.acceptWalkie(lat: latitude, long: longitude)
                    }
                }
            }
            })
        
        
    }//observerMessagesForDogsitter
    
}//class
