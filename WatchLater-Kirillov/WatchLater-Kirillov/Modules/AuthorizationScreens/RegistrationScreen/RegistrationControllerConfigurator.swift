//
//  RegistrationControllerConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class RegistrationControllerConfigurator {
    
    func setupModule() -> RegistrationViewController {
        let viewController = RegistrationViewController()
        let presenter = RegistrationPresenter(viewController: viewController)
        let interactor = RegistrationInteractor(
            presenter: presenter,
            networkService: RegistrationService(networkLayer: NetworkLayer(),
                                                loginService: LoginService(networkLayer: NetworkLayer()))
        )
        viewController.setupComponents(interactor: interactor)
        return viewController
    }
}
