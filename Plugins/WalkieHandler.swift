//
//  WalkeHandler.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 5..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import Foundation
import FirebaseDatabase

//for owner
protocol WalkieOwnerController: class{
    func canCallWalkie(delegateCalled: Bool)
    func dogSitterAcceptedRequest(requestAccepted: Bool, dogSitterName: String)
}

protocol WalkieController: class{
    func acceptWalkie(lat: Double, long: Double)
    func ownerCancelledWalkie()
}

class WalkieHandler{
    

    
    private static let _instance = WalkieHandler()
    weak var delegate: WalkieController?
    weak var delegateOwner : WalkieOwnerController?
    
    var owner = ""
    var owner_id = ""
    var dogSitter = ""
    var dogSitter_id = ""
    
    static var Instance: WalkieHandler{
        return _instance
    }
    
    //for owner
    func observeMessagesForOwner(){
        //owner requested walkie
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                if let name = data[Constants.NAME] as? String{
                    if name == self.owner{
                        self.owner_id = DataSnapshot.key
                        self.delegateOwner?.canCallWalkie(delegateCalled: true)
                    }
                }
                
            }
        }
        
        //owner canceled walkie
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved) { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                if let name = data[Constants.NAME] as? String{
                    if name == self.owner{
                        self.delegateOwner?.canCallWalkie(delegateCalled: false)
                    }
                }
                
            }
        }
        
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                if let name = data[Constants.NAME] as? String{
                    if self.owner == ""{
                        self.owner = name
                        self.delegateOwner?.dogSitterAcceptedRequest(requestAccepted: true, dogSitterName: self.dogSitter)
                    }
                }
            }
        }
        
    }
    
    func requestWalkie(latitude: Double, longtitude: Double){
        let data : Dictionary<String, Any> = [Constants.NAME: owner, Constants.LATITUDE: latitude,Constants.LONGITUDE: longtitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }//request Walkie
    
    
    //for owner
    func cancelWalkie(){
        DBProvider.Instance.requestRef.child(owner_id).removeValue()
    }
    
    //for dog sitter
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
                if let name = data[Constants.NAME] as? String{
                    self.owner = name
                }
            }
            
            //owner cancelled walkie
            DBProvider.Instance.requestRef.observe(DataEventType.childRemoved, with: { (DataSnapshot) in
                if let data = DataSnapshot.value as? NSDictionary{
                    if let name = data[Constants.NAME] as? String{
                        if name == self.owner{
                            self.owner = ""
                            self.delegate?.ownerCancelledWalkie()
                            
                        }
                    }
                }
            })
            })
        
        
    }//observerMessagesForDogsitter
    
    //for dogSitter
    
    func walkieAccepted(lat: Double, long: Double){
        
        let data: Dictionary<String, Any> = [Constants.NAME: dogSitter, Constants.LATITUDE: lat, Constants.LONGITUDE: long]
        
        DBProvider.Instance.requestAcceptedRef.childByAutoId().setValue(data)
    }
    
}//class
