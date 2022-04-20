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

enum RError: Error, LocalizedError {

    case unowned
    case alreadyExist(String)
    case badEmailFormat(String)
    
    public var errorDescription: String? {
        switch self {
        case .unowned:
            return NSLocalizedString(Text.Authorization.somethingWentWrong, comment: "Unowned Error")
        
        case .alreadyExist(let description):
            return NSLocalizedString(description, comment: "Email Already Exist")
            
        case .badEmailFormat(let description):
            return NSLocalizedString(description, comment: "Bad email format")
        }
    }
}
