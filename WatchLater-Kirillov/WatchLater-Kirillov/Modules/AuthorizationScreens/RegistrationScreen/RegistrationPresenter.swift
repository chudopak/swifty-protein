//
//  RegistrationPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class RegistrationPresenter {

    weak var registrationViewController: RegistrationViewController!
    
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
