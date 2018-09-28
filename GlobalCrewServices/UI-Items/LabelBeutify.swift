//
//  LabelBeutify.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/27/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class LabelBeutify: UILabel {
    
    
    override func awakeFromNib() {
        self.font = UIFont(name: "Avenir Next", size: 16)
        self.textColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 5 + 0,
                      height: size.height + 0 + 0)
    }
    
    override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

