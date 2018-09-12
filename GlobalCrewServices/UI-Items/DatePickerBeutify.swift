//
//  DatePickerBeutify.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class DatePickerBeutify: UIDatePicker {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setValue(UIColor.white, forKey: "textColor")
    }

}
