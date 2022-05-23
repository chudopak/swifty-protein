//
//  ProfileRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class ProfileRouter {
    
    private weak var viewController: ProfileViewController!
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
    
    func presentEditProfileScreen(navigationController: UINavigationController, userInfo: UserInfo?) {
        let editProfileVC = EditProfileConfigurator().setupModule(userInfo: userInfo)
        navigationController.pushViewController(editProfileVC, animated: true)
    }
}
