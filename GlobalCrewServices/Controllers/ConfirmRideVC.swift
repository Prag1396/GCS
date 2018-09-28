//
//  ConfirmRideVC.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/27/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmRideVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var vesselNameLbl: LabelBeutify!
    @IBOutlet weak var fromLocationLbl: LabelBeutify!
    @IBOutlet weak var toLocationLbl: LabelBeutify!
    @IBOutlet weak var pickupDetailsLbl: LabelBeutify!
    
    @IBOutlet weak var notesView: textViewBeutify!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    
    private var _vesselText: String = ""
    private var _fromLocationtext: String = ""
    private var _toLocationtext: String = ""
    private var _pickupdetailstext: String = ""
    private var _confirmationCode: String = ""
    
    var vesselText: String = "" {
        didSet {
            self._vesselText = vesselText
        }
    }
    
    var fromLocText: String = "" {
        didSet {
            self._fromLocationtext = fromLocText
        }
    }
    
    var toLocText: String = "" {
        didSet {
            self._toLocationtext = toLocText
        }
    }
    
    var pickUpDetailsText: String = "" {
        didSet {
            self._pickupdetailstext = pickUpDetailsText
        }
    }
    
    var confirmCodeText: String = "" {
        didSet {
            self._confirmationCode  = confirmCodeText
        }
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesView.delegate = self
        setUpLabels()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundImage.addGestureRecognizer(tap)
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChange(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChange(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChange(notification:)), name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyBoardChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIWindow.keyboardWillChangeFrameNotification || notification.name == UIWindow.keyboardWillShowNotification {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
     func setUpLabels() {
    
        print(self._vesselText, self._fromLocationtext, self._toLocationtext, self._pickupdetailstext, self._confirmationCode)
        DispatchQueue.main.async {
            self.vesselNameLbl.text = self._vesselText
            self.fromLocationLbl.text = self._fromLocationtext
            self.toLocationLbl.text = self._toLocationtext
            self.pickupDetailsLbl.text = self._pickupdetailstext
        }

        
    }
    
    @IBAction func confirmRideClicked(_ sender: Any) {
        
        //        let userData = ["Vessel_Name": vesselName, "From_Port": self.fromLocation, "To_Port": self.toLocation, "Date_and_Time": self.pickUpDetails, "confirmationCode": "\(bookingConfirmation)"]
        //        DataService.instance.createDBUserProfile(uid: uid, userData: userData as! Dictionary<String, String>)
        //        confirmationDisplay()
    }
    
    func confirmationDisplay() {
        let alert = UIAlertController(title: "Congratulations", message: "Your Ride has been confirmed. Details along with the confirmation code have been sent to your dispatch email. Please check email for further inquiries", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetSizeforTextView(textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
            let difference = estimatedSize.height - 15
            self.noteHeight.constant = 35 + difference
        }
    }
    
    
    
}

extension ConfirmRideVC: UITextViewDelegate {
  
    func textViewDidChange(_ textView: UITextView) {
        self.resetSizeforTextView(textView: textView)
    }
}
