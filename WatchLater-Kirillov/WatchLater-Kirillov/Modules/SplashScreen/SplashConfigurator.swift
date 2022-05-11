//
//  SplashConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit

final class SplashConfigurator {
    
    func setupController() -> SplashViewController {
        let vc = SplashViewController()
        let refreshService = RefreshTokenService()
        let presenter = SplashPresenter(viewController: vc)
        let interactor = SplashInteractor(presenter: presenter,
                                          refreshTokenService: refreshService)
        let router = SplashRouter(viewController: vc)
        vc.setupComponents(interactor: interactor,
                           router: router)
        return vc
    }
}
