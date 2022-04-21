//
//  LoginRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum LoginRouter {
    
    private static var loginVC: LoginViewController?
    
    static func makeLoginViewController() -> LoginViewController {
        if loginVC == nil {
            loginVC = LoginControllerConfigurator().setupModule()
        }
        return (loginVC!)
    }
    
    static func removeViewController() {
        loginVC = nil
    }
}
