//
//  EditProfileRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class EditProfileRouter {
    
    private weak var viewController: EditProfileViewController!
    
    init(viewController: EditProfileViewController) {
        self.viewController = viewController
    }
    
    func getBackToPreviousScreen(navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
}
