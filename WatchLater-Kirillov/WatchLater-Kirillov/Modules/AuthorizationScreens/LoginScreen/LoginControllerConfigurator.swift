//
//  LoginControllerConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class LoginControllerConfigurator {
    
    func setupModule() -> LoginViewController {
        let viewController = LoginViewController()
        let presenter = LoginPresenter(viewController: viewController)
        let interactor = LoginInteractor(
            presenter: presenter,
            networkService: LoginService(networkLayer: NetworkLayer())!
        )
        viewController.setupComponents(interactor: interactor)
        return viewController
    }
}
