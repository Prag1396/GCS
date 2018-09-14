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
    
    
    private var gcscode: String = "0047"
    private var numPadArray: [UIButton] = []
    private var authFillArray: [UIImageView] = []
    
    private var _user: User?
    private var _uid: String?
    
    private var currCode: String = ""
    
    var user: User? {
        return _user
    }
    
    var uid: String? {
        return _uid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.width)
        self.setUpKeyPad()
        self.keyPadViewTopContraint.constant = self.view.frame.height
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
    
    func setUpKeyPad() {
        
        numPadArray = [number0, number1, number2, number3, number4, number5, number6, number7, number8,  number9]
        authFillArray = [authCodeFill1, authCodeFill2, authCodeFill3, authCodeFill4]
        for pad in numPadArray {
            pad.addTarget(self, action: #selector(takeInputfromPad), for: .touchUpInside)
        }
        backspace.addTarget(self, action: #selector(backspacePressed), for: .touchUpInside)
        
    }
    
    @objc func backspacePressed() {
        if currCode.count > 0 {
            let originalImage = authFillArray[currCode.count - 1].image?.withRenderingMode(.alwaysOriginal)
            authFillArray[currCode.count - 1].image = originalImage
            currCode.removeLast()
        }
    }
    
    @objc func takeInputfromPad(sender: UIButton) {
        //Check code and append to string
        currCode.append(String(sender.tag))
        fillAuthCircles()
        if currCode.count == 4 {
            valiDateCode()
        }
    }
    
    func fillAuthCircles() {
        let templateImage = authFillArray[currCode.count - 1].image?.withRenderingMode(.alwaysTemplate)
        authFillArray[currCode.count - 1].image = templateImage
        authFillArray[currCode.count - 1].tintColor = UIColor.gray
    }
    
    func resetAuthCircles() {
        for index in 0...authFillArray.count - 1 {
            let originalImage = authFillArray[index].image?.withRenderingMode(.alwaysOriginal)
            authFillArray[index].image = originalImage
        }
        
    }
    
    func valiDateCode() {
        if currCode == gcscode {
            self.createAnonymousUser {
                self.dismissAuthView()
                self.performSegue(withIdentifier: "toridedetailsvc", sender: (Any).self)
            }
        } else {
            //show alert saying code does not match
            print("Failure")
            let alert = UIAlertController(title: "Alert", message: "Wrong Code. Please contact Global Crew Services for personalized Transportational Services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in }))
            self.present(alert, animated: true) {
                self.resetAuthCircles()
            }
        }
        self.resetCurrentCode()
    }
    
    func dismissAuthView() {
        UIView.animate(withDuration: 0.5) {
            self.keyPadViewTopContraint.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func resetCurrentCode() {
        currCode = ""
    }
    
    @IBAction func requestRidePressed(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
            print("First Launch")
            do {
                try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
            
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
            
            self.displayAuthView()
            
        } else {
            print("Not First Launch")
            self._user = Auth.auth().currentUser
            self._uid = Auth.auth().currentUser?.uid
            performSegue(withIdentifier: "toridedetailsvc", sender: (Any).self)
        }
    }
    
    func displayAuthView() {
        UIView.animate(withDuration: 1.0) {
            self.keyPadViewTopContraint.constant = 170
            self.view.layoutIfNeeded()
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
                self._user = AuthResult?.user
                self._uid = AuthResult?.user.uid
                onComplete()
            }
            
        }
        
    }
    
}

