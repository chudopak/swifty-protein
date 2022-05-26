//
//  SplashRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit

final class SplashRouter {
    
    private weak var viewController: SplashViewController!
    
    init(viewController: SplashViewController) {
        self.viewController = viewController
    }
    
    func presentLoginViewController() {
        let loginVC = LoginRouter.makeLoginViewController()
        let navigationController = BaseNavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        UIWindowService.replaceRootViewController(with: navigationController)
    }
    
    func presentMainTabBar() {
        let tapBar = MainTabBar()
        UIWindowService.replaceRootViewController(with: tapBar)
    }
}
