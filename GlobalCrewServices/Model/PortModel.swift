//
//  DateModel.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import Foundation

class PortModel {
    
    private var _portCode: String!
    private var _portCity: String!
    
    var portCode: String {
        if _portCode == nil {
            _portCode = ""
        }
        return _portCode
    }
    
    var portCity: String {
        if _portCity == nil {
            _portCity = ""
        }
        return _portCity
    }
    
    init(portCode: String, portCity: String) {
        self._portCode = portCode
        self._portCity = portCity
    }
}
