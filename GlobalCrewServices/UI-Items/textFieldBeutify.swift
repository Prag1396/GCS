//
//  textFieldBeutify.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class textFieldBeutify: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        if self.tag != 1 {
            self.attributedPlaceholder = NSAttributedString(string: "VESSEL NAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            self.attributedPlaceholder = NSAttributedString(string: "ADD NOTES (OPTIONAL)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        }
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        
    }
   

}
