//
//  ProfileConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class ProfileConfigurator {
    
    func setupModule() -> ProfileViewController {
        let vc = ProfileViewController()
        let router = ProfileRouter(viewController: vc)
        vc.setupComponents(router: router)
        return vc
    }
}
