//
//  AuthService.swift
//  GlobalCrewServices
//
//  Created by Pragun Sharma on 9/12/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    static let instance = AuthService()

func handleErrorCode(error: NSError, onCompleteErrorHandler: @escaping(_ errorMsg: String, _ data: AnyObject?)->()) {
    if let errorCode = AuthErrorCode(rawValue: error.code) {
        switch (errorCode) {
        case .tooManyRequests: do {
            onCompleteErrorHandler("Too many requests from this device. Please try again later", nil)
            }
        case .userTokenExpired: do {
            onCompleteErrorHandler("Session has expired. Please try again", nil)
            }
        case .userDisabled: do {
            onCompleteErrorHandler("Your accunt has been disabled. Please contact the admin", nil)
            }
        case .invalidPhoneNumber: do {
            onCompleteErrorHandler("Invalid Phone number. Enter phone number again with country code", nil)
            }
        case .webNetworkRequestFailed: do {
            onCompleteErrorHandler("Network Error. Please try again later", nil)
            }
        case .networkError: do {
            onCompleteErrorHandler("Session Timed out. Please try again", nil)
            }
        case .wrongPassword: do {
            onCompleteErrorHandler("Invalid Passcode", nil)
            }
        case .invalidVerificationCode: do {
            onCompleteErrorHandler("Invalid Code. Please try again", nil)
            }
        case .credentialAlreadyInUse: do {
            onCompleteErrorHandler("Phone number already in use", nil)
            }
        case .userNotFound: do {
            onCompleteErrorHandler("User not found. Please sign up", nil)
            }
        case .sessionExpired: do {
            onCompleteErrorHandler("Session Expired", nil)
            }
        case .invalidEmail: do {
            onCompleteErrorHandler("Invalid Email", nil)
            }
            
        default:
            onCompleteErrorHandler("Internal Error. Please try again.", nil)
            
        }
    }
}
}
