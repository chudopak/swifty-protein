//
//  LoginPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol LoginPresenterProtocol {
    func procedLoginResult(state: LoginResponseState)
}

final class LoginPresenter: LoginPresenterProtocol {

    private weak var loginViewController: LoginViewController!
    
    init(viewController: LoginViewController) {
        loginViewController = viewController
    }
    
    func procedLoginResult(state: LoginResponseState) {
    }
}
