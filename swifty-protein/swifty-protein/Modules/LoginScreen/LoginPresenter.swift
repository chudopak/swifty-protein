//
//  LoginPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

protocol LoginPresenterProtocol {
    func handleNewPasswordNumber(number: Int)
    func deleteLastNumber()
}

final class LoginPresenter: LoginPresenterProtocol {
    
    private var password = ""
    
    private weak var viewController: LoginViewControllerProtocol!
    
    init(viewController: LoginViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func handleNewPasswordNumber(number: Int) {
        if password.count < LoginSizes.passwordLength {
            viewController.changePasswordLabelState(index: password.count, isFilled: true)
            password.append(String(number))
            print(password)
        }
        if password.count == LoginSizes.passwordLength {
            // TODO: show question popup 
        }
    }
    
    func deleteLastNumber() {
        if !password.isEmpty {
            password.removeLast()
            viewController.changePasswordLabelState(index: password.count, isFilled: false)
        }
    }
}
