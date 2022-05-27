//
//  RegistrationViewControllerSpy.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

class RegistrationViewControllerSpy: RegistrationViewControllerProtocol {
    var isPresentThumbnailsViewControllerCalled = false
    var isRegistrationFailedStateCalled = false
    var isPresentLoginAlertCalled = false
    
    func registrationFailedState(displayMessage: String) {
        isRegistrationFailedStateCalled = true
    }
    
    func presentThumbnailsViewController() {
        isPresentThumbnailsViewControllerCalled = true
    }
    
    func presentLoginViewControllerWithLoginAlert() {
        isPresentLoginAlertCalled = true
    }
}
