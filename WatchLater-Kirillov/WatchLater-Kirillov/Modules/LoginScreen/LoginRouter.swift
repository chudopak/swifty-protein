//
//  LoginRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum LoginRouter {
    
    static func makeLoginViewController() -> LoginViewController {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        return (loginVC)
    }
}
