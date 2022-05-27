//
//  LoginPresenterSpy.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/27/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

final class LoginPresenterSpy: LoginPresenterProtocol {
    
    var success = false
    var isCalled = false
    var failed = false
    
    func procedLoginResult(state: LoginResponseState) {
        isCalled = true
        success = true
        failed = false
    }
    
    func failedToLogin(message: String) {
        isCalled = true
        success = false
        failed = true
    }
}
