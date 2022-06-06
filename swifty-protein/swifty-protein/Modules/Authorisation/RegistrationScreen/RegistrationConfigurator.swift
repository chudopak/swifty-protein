//
//  RegistrationConfigurator.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/6/22.
//

import UIKit

final class RegistrationConfigurator {
    
    func setupModule() -> RegistrationViewController {
        let vc = RegistrationViewController()
        let presenter = RegistrationPresenter(viewController: vc)
        vc.setupComponents(presenter: presenter)
        return vc
    }
}
