//
//  ViewController.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/11/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    @IBOutlet weak var requestRideButton: UIButton!
    
    
    //KeyPadView
    @IBOutlet weak var keypadView: UIView!
    @IBOutlet weak var keyPadViewTopContraint: NSLayoutConstraint!
    
    
    //Fill Auth Codes
    @IBOutlet weak var authCodeFill1: UIImageView!
    @IBOutlet weak var authCodeFill2: UIImageView!
    @IBOutlet weak var authCodeFill3: UIImageView!
    @IBOutlet weak var authCodeFill4: UIImageView!
    
    //KeyPad
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var backspace: UIButton!
    
    
    
    
    private var _user: User?
    private var _uid: String?
    
    var user: User? {
        return _user
    }
    
    var uid: String? {
        return _uid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestRideButton.isUserInteractionEnabled = false
        self.createAnonymousUser {
            self.requestRideButton.isUserInteractionEnabled = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toridedetailsvc") {
            if let destination = segue.destination as? RideDetailsVC {
                if self._uid != nil && self._user != nil {
                    destination.user = self._user
                    destination.uid = self._uid
                }
            }
            
        }
    }
    
    
    @IBAction func requestRidePressed(_ sender: Any) {
        performSegue(withIdentifier: "toridedetailsvc", sender: (Any).self)
    }
    
    func createAnonymousUser(onComplete: @escaping()->()) {
    
        //make new UserID
        Auth.auth().signInAnonymously { (AuthResult, error) in
            if error != nil {
                AuthService.instance.handleErrorCode(error: error! as NSError, onCompleteErrorHandler: { (messageString, object) in
                    //Present Alert
                    let alert = UIAlertController(title: "Alert", message: messageString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Alerty", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            } else {
                self._user = AuthResult?.user
                self._uid = AuthResult?.user.uid
                onComplete()
            }
            
        }
        
    }
    
}

