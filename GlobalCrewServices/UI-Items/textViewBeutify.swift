//
//  textViewBeutify.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/27/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class textViewBeutify: UITextView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }

    
}
