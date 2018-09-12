//
//  PortModelPicker.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class PortModelPicker: UIPickerView {

    var portModelArray: [PortModel] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 0 // Main view rounded border
        
        // Component borders
        self.subviews.forEach {
            $0.layer.borderWidth = 0
            $0.isHidden = $0.frame.height <= 1.0
        }
    }
    
}

extension PortModelPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return portModelArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 125
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 100))
        
        let codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 125, height: 50))
        codeLabel.text = portModelArray[row].portCode
        codeLabel.textColor = UIColor.white
        codeLabel.textAlignment = .center
        codeLabel.font = UIFont(name: "Avenir Next", size: 24)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeLabel)
        
        let xConstraint = NSLayoutConstraint(item: codeLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: codeLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -20)
        
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])

        
        
        let cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 125, height: 25))
        cityLabel.text = portModelArray[row].portCity
        cityLabel.textAlignment = .center
        cityLabel.textColor = UIColor.white
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont(name: "Avenir Next", size: 18)
        view.addSubview(cityLabel)
        
        let xConstraintcityLabel = NSLayoutConstraint(item: cityLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraintcityLabel = NSLayoutConstraint(item: cityLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([xConstraintcityLabel, yConstraintcityLabel])
        
        pickerView.layer.borderColor = UIColor.white.cgColor
        
        view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
        return view
    }
    
    
}
