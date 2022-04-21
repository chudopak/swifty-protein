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
            DispatchQueue.main.async { [unowned self] in
                self.registrationViewController.presentThumbnailsViewController()
            }
        
        case let .failure(displayMessage, error):
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async { [unowned self] in
                self.registrationViewController.registrationFailedState(displayMessage: displayMessage)
            }
            
        case .loginFailed:
            DispatchQueue.main.async { [unowned self] in
                self.registrationViewController.presentLoginViewControllerWithLoginAlert()
            }
        }
    }
}
