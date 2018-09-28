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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var _vesselText: String = ""
    private var _fromLocationtext: String = ""
    private var _toLocationtext: String = ""
    private var _pickupdetailstext: String = ""
    private var _confirmationCode: String = ""
    private var _notes: String = ""
    
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
        notesView.scrollsToTop = true
        setUpLabels()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundImage.addGestureRecognizer(tap)
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

    }
    
    func scrollToTop() {
        self.notesView.setContentOffset(.zero, animated: false)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func backgroundTapped() {
        self.scrollToTop()
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
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self._notes = notesView.text
        
        let userData = ["Vessel_Name": self._vesselText, "From_Port": self._fromLocationtext, "To_Port": self._toLocationtext, "Date_and_Time": self._pickupdetailstext, "confirmationCode": self._confirmationCode, "Notes": self._notes]
        DataService.instance.createDBUserProfile(uid: uid, userData: userData)
        confirmationDisplay()
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
        if estimatedSize.height < 80 {
            textView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
                let difference = estimatedSize.height - 15
                self.noteHeight.constant = 35 + difference
            }
        }
    }
    
}

extension ConfirmRideVC: UITextViewDelegate {
  
    func textViewDidChange(_ textView: UITextView) {
        self.resetSizeforTextView(textView: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.scrollToTop()
            return false
        }
        return true
    }

}
