//
//  LoginModel.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct LoginData: Codable {
    let email: String
    let password: String
}

enum TextFieldType {
    case password, repeatPassword, email
}

enum LoginResponseState {
    case success
    case failure(String, Error?)
}

struct Tokens: Codable {
    let accessToken: String
    let refreshToken: String
}
