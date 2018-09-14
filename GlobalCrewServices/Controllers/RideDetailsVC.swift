//
//  RideDetailsVC.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class RideDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var textFieldVesselName: textFieldBeutify!
    @IBOutlet weak var fromLocationPickerView: UIPickerView!
    @IBOutlet weak var toLocationPickerView: UIPickerView!
    @IBOutlet weak var pickUpDetailsPickerView: UIDatePicker!
    
    var PortModelArray: [PortModel] = []
    var portModelPicker: PortModelPicker!
    var rotationAngle: CGFloat = -90 * (.pi/180)
    
    //Details
    var vesselName: String!
    var fromLocation: String!
    var toLocation: String!
    var pickUpDetails: String!
    
    //User
    var user: User?
    var uid: String?
    
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portModelPicker = PortModelPicker()
        
        self.parseCSV {
            self.portModelPicker.portModelArray = self.PortModelArray
            
        }
        
        textFieldVesselName.delegate = self
        
        var originalY = fromLocationPickerView.frame.origin.y
        fromLocationPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        fromLocationPickerView.frame = CGRect(x: -140, y: originalY, width: view.frame.width + 220, height: 100)
        fromLocationPickerView.delegate = portModelPicker
        fromLocationPickerView.dataSource = portModelPicker
        fromLocationPickerView.selectRow(2, inComponent: 0, animated: true)
        
        originalY = toLocationPickerView.frame.origin.y
        toLocationPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        toLocationPickerView.frame = CGRect(x: -140, y: originalY, width: view.frame.width + 220, height: 100)
        toLocationPickerView.delegate = portModelPicker
        toLocationPickerView.dataSource = portModelPicker
        toLocationPickerView.selectRow(2, inComponent: 0, animated: true)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        background.addGestureRecognizer(tap)
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    func parseCSV(OnComplete: @escaping () -> ()) {
        
        guard let path = Bundle.main.path(forResource: "Port-List", ofType: "csv") else { return }
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in 0...rows.count - 1 {
                if let code = rows[row]["Code"], let location = rows[row]["Location"] {
                    let portModelObject = PortModel(portCode: code, portCity: location)
                    PortModelArray.append(portModelObject)
                }
            }
            OnComplete()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func confirmRideClicked(_ sender: Any) {
        
        self.fromLocation = portModelPicker.portModelArray[fromLocationPickerView.selectedRow(inComponent: 0)].portCity
        self.toLocation = portModelPicker.portModelArray[toLocationPickerView.selectedRow(inComponent: 0)].portCity
        dateFormatter.setLocalizedDateFormatFromTemplate("cccc, MMM d, hh:mm aa")
        self.pickUpDetails = dateFormatter.string(from: pickUpDetailsPickerView.date)
        
        uploadRideDetails()
        
    }
    
    func uploadRideDetails() {
        
        guard let vesselName = self.textFieldVesselName.text, vesselName != "" else {
            //Present alert
            let alert = UIAlertController(title: "Alert", message: "Please Enter Vessel Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.textFieldVesselName.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
            
            return }
        
        guard let uid = self.uid else { return }
        let bookingConfirmation = Int(arc4random_uniform(100000) + 1)
        let userData = ["Vessel_Name": vesselName, "From_Port": self.fromLocation, "To_Port": self.toLocation, "Date_and_Time": self.pickUpDetails, "confirmationCode": "\(bookingConfirmation)"]
        DataService.instance.createDBUserProfile(uid: uid, userData: userData as! Dictionary<String, String>)
        confirmationDisplay()
        
    }
    
    func confirmationDisplay() {
        let alert = UIAlertController(title: "Congratulations", message: "Your Ride has been confirmed. Details along with the confirmation code have been sent to your dispatch email. Please check email for further inquiries", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension RideDetailsVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder?.removeAll()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let _ = textField.text else {
        textField.attributedPlaceholder = NSAttributedString(string: "VESSEL NAME", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! || textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: "VESSEL NAME", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        textField.resignFirstResponder()
        return false
    }
    
}
