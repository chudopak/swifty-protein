//
//  LoginServiceSpy.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/27/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

final class LoginServiceLoginSucceedSpy: LoginServiceProtocol {
    
    var isCalled = false
    
    func login(with data: LoginData, completion: @escaping (LoginResponseState) -> Void) {
        isCalled = true
        completion(.success)
    }
}
