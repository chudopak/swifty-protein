//
//  RegistrationRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/14/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum RegistrationRouter {
    
    private static var registrationVC: RegistrationViewController?
    
    static func presentRegistrationViewController(navigationController: UINavigationController) {
        if registrationVC == nil {
            let presenter = RegistrationPresenter()
            let interactor = RegistrationInteractor(presenter: presenter)
            registrationVC = RegistrationViewController(interactor: interactor)
            presenter.registrationViewController = registrationVC
        }
        navigationController.pushViewController(registrationVC!, animated: true)
    }
}
