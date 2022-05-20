//
//  EditProfileConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class EditProfileConfigurator {
    
    func setupModule() -> EditProfileViewController {
        let vc = EditProfileViewController()
        let router = EditProfileRouter(viewController: vc)
        vc.setupComponents(router: router)
        return vc
    }
}
