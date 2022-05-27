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
    func failedToLogin(message: String)
}

final class LoginPresenter: LoginPresenterProtocol {

    private weak var loginViewController: LoginViewControllerProtocol!
    
    init(viewController: LoginViewControllerProtocol) {
        loginViewController = viewController
    }
    
    func procedLoginResult(state: LoginResponseState) {
        switch state {
        case .success:
            DispatchQueue.main.async { [weak self] in
                self?.loginViewController.presentFavouriteViewController()
            }

        case let .failure(displayMessage, error):
            if let error = error {
                print("LoginPresentererror, procedLoginResult - ", error.localizedDescription)
            }
            DispatchQueue.main.async { [weak self] in
                self?.loginViewController.loginFailedState(displayMessage: displayMessage)
            }
        }
    }
    
    func failedToLogin(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.loginViewController.loginFailedState(displayMessage: message)
        }
    }
}
