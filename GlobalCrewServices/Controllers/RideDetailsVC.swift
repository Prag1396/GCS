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
    @IBOutlet weak var confirmRideBtn: UIButton!
    
    var PortModelArray: [PortModel] = []
    var portModelPicker: PortModelPicker!
    var rotationAngle: CGFloat = -90 * (.pi/180)
    
    //Details
    var vesselName: String!
    var fromLocation: String!
    var toLocation: String!
    var pickUpDetails: String!
    var bookingConfirmation: Int!
    
    let currentDate: Date = Date()
    
    //User
    private var _user: User?
    private var _uid: String?
    
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portModelPicker = PortModelPicker()
        checkifLaunchedBefore()
        self.parseCSV {
            self.portModelPicker.portModelArray = self.PortModelArray
        }
        textFieldVesselName.delegate = self
        
        var originalY = fromLocationPickerView.frame.origin.y
        fromLocationPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        fromLocationPickerView.frame = CGRect(x: -100, y: originalY, width: view.frame.width + 200, height: 100)
        fromLocationPickerView.delegate = portModelPicker
        fromLocationPickerView.dataSource = portModelPicker
        fromLocationPickerView.selectRow(2, inComponent: 0, animated: true)
        
        originalY = toLocationPickerView.frame.origin.y
        toLocationPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        toLocationPickerView.frame = CGRect(x: -100, y: originalY, width: view.frame.width + 200, height: 100)
        toLocationPickerView.delegate = portModelPicker
        toLocationPickerView.dataSource = portModelPicker
        toLocationPickerView.selectRow(2, inComponent: 0, animated: true)
        
        pickUpDetailsPickerView.minimumDate = currentDate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        background.addGestureRecognizer(tap)
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    func checkifLaunchedBefore() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
            
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
            self.createAnonymousUser {
                self.confirmRideBtn.isUserInteractionEnabled = true
            }
        } else {
            self._uid = Auth.auth().currentUser?.uid
        }
    }
    
    func createAnonymousUser(onComplete: @escaping()->()) {
        
        //make new UserID
        Auth.auth().signInAnonymously { (AuthResult, error) in
            if error != nil {
                AuthService.instance.handleErrorCode(error: error! as NSError, onCompleteErrorHandler: { (messageString, object) in
                    //Present Alert
                    let alert = UIAlertController(title: "Alert", message: messageString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            } else {
                self._uid = AuthResult?.user.uid
                onComplete()
            }
            
        }
        
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
        
        createRideModel()
        
        guard let vname = self.textFieldVesselName.text, vname != "" else {
            //Present alert
            let alert = UIAlertController(title: "Alert", message: "Please Enter Vessel Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.textFieldVesselName.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
            
            return }
        
        self.vesselName = vname
        let confirmRideVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmRideVC") as? ConfirmRideVC
        guard let confirmrideVC = confirmRideVC else { return }
        
        confirmrideVC.vesselText = self.vesselName
        confirmrideVC.fromLocText = self.fromLocation
        confirmrideVC.toLocText = self.toLocation
        confirmrideVC.pickUpDetailsText = self.pickUpDetails
        confirmrideVC.confirmCodeText = String(self.bookingConfirmation)
        self.present(confirmrideVC, animated: true, completion: nil)
        
        
    }
    
    
    
    func createRideModel() {
        
        self.fromLocation = portModelPicker.portModelArray[fromLocationPickerView.selectedRow(inComponent: 0)].portCity
        self.toLocation = portModelPicker.portModelArray[toLocationPickerView.selectedRow(inComponent: 0)].portCity
        dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy HH:mm")
        self.pickUpDetails = dateFormatter.string(from: pickUpDetailsPickerView.date)
        
        //guard let uid = self._uid else { return }
        self.bookingConfirmation = Int(arc4random_uniform(100000) + 1)
        
    }
        
}

extension RideDetailsVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder?.removeAll()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let _ = textField.text else {
        textField.attributedPlaceholder = NSAttributedString(string: "VESSEL NAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! || textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: "VESSEL NAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        textField.resignFirstResponder()
        return false
    }
    
}
