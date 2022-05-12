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
            registrationVC = RegistrationControllerConfigurator().setupModule()
        }
        navigationController.pushViewController(registrationVC!, animated: true)
    }
    
    static func removeViewController() {
        registrationVC = nil
    }
    
    static func presentViewController(_ viewController: UIViewController) {
        UIWindowService.replaceRootViewController(with: FavouriteThumbnailsViewController())
        RegistrationRouter.removeViewController()
        LoginRouter.removeViewController()
    }
    
    static func popViewController(from navigationController: UINavigationController, animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
