//
//  LoginConfigurator.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

final class LoginConfigurator {
    
    func setupModule() -> LoginViewController {
        let vc = LoginViewController()
        let presenter = LoginPresenter(viewController: vc)
        vc.setupComponents(presenter: presenter)
        return vc
    }
}
