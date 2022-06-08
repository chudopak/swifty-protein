//
//  RegistrationPresenterSpy.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

final class RegistrationPresenterSpy: RegistrationPresenterProtocol {
    
    var isCalled = false
    var isProceedRegistrationResult = false
    var isShowFailedState = false
    
    func proceedRegistrationResult(state: RegistrationResponseState) {
        isCalled = true
        isProceedRegistrationResult = true
    }
    
    func showFailedState(message: String) {
        isCalled = true
        isShowFailedState = true
    }
}
