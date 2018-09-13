//
//  DataService.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_RIDES = DB_BASE.child("rides")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_RIDES: DatabaseReference {
        return _REF_RIDES
    }
    
    func createDBUserProfile(uid: String, userData: Dictionary <String, String>) {
        
        let refNode = REF_RIDES.childByAutoId()
        refNode.setValue(userData)
        let orderID = refNode.key
        REF_USERS.child(uid).updateChildValues([orderID : 1])
    }
}
