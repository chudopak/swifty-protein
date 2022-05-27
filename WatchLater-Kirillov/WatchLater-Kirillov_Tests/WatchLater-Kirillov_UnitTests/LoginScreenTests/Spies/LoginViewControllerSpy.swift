//
//  LoginViewControllerSpy.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

class LoginViewControllerSpy: LoginViewControllerProtocol {
    
    var isLoginFailedStateCalled = false
    var isPresentFavouriteViewController = false
    
    func loginFailedState(displayMessage: String) {
        isLoginFailedStateCalled = true
    }
    
    func presentFavouriteViewController() {
        isPresentFavouriteViewController = true
    }
}
