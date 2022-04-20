//
//  RegistrationPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol RegistrationPresenterProtocol {
    func proceedRegistrationResult(state: RegistrationResponseState)
}

final class RegistrationPresenter: RegistrationPresenterProtocol {

    private weak var registrationViewController: RegistrationViewController!
    
    init(viewController: RegistrationViewController) {
        registrationViewController = viewController
    }
    
    func proceedRegistrationResult(state: RegistrationResponseState) {
        switch state {
        case .success:
            registrationViewController.presentThumbnailsViewController()
        
        case let .failure(displayMessage, error):
            print(error.localizedDescription)
            registrationViewController.registrationFailedState(displayMessage: displayMessage)
            
        case .loginFailed:
            // TODO: present loginViewController and show alert that user should register
            break
        }
    }
}
