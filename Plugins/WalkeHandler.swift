//
//  WalkeHandler.swift
//  Walkie
//
//  Created by wonjongpill on 2018. 1. 5..
//  Copyright © 2018년 Jayron Cena. All rights reserved.
//

import Foundation
import FirebaseDatabase

class WalkieHandler{
    

    
    private static let _instance = WalkieHandler()
    
    var dogSitter = ""
    var owner = ""
    var dogSitter_id = ""
    
    static var Instance: WalkieHandler{
        return _instance
    }
    
}//class
