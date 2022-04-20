//
//  RegistrationModel.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/15/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct RegistrationData: Codable {
    let email: String
    let password: String
}

struct RegistrationError: Codable {
    let message: String
    let timestamp: String
}

enum RegistrationResponseState {
    case success
    case failure(String, Error)
    case loginFailed
}

enum RError: Error, LocalizedError {

    case unowned
    case alreadyExist
    case badEmailFormat
    
    public var errorDescription: String? {
        switch self {
        case .unowned:
            return NSLocalizedString("Something went wrong",
                                     comment: "Unowned Error")
        
        case .alreadyExist:
            return NSLocalizedString("User trying to use email that already registered in data base",
                                     comment: "Email Already Exist")
            
        case .badEmailFormat:
            return NSLocalizedString("User trying to register without email address",
                                     comment: "Bad email format")
        }
    }
}
