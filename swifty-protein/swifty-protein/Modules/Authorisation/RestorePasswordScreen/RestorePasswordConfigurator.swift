//
//  RestorePasswordConfigurator.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

final class RestorePasswordConfigurator {
    
    func setupModule() -> RestorePasswordViewController {
        let vc = RestorePasswordViewController()
        let presenter = RestorePasswordPresenter(viewController: vc)
        vc.setupComponents(presenter: presenter)
        return vc
    }
}
