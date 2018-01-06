//
//  DBProvider.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 5..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider{
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider{
        return _instance
    }
    
    var dbRef: DatabaseReference{
        return Database.database().reference()
    }
    
    var dogOwnerRef: DatabaseReference{
        return dbRef.child(Constants.OWNER)
    }
    var dogSitterRef: DatabaseReference{
        return dbRef.child(Constants.DOGSITTER)
    }
    
    var requestRef: DatabaseReference{
        return dbRef.child(Constants.WALKER_REQUEST)
    }
    
    var requestAcceptedRef: DatabaseReference{
        return dbRef.child(Constants.WALKER_ACCEPTED)
    }
    
    
    func saveUserOwner(withID: String, email: String, password: String){
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isDOGSITTER: false]
        
        dogOwnerRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
    
    func saveUserDogSitter(withID: String, email: String, password: String){
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isDOGSITTER: true]
        
        dogSitterRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
    
    
    
    
}//class
