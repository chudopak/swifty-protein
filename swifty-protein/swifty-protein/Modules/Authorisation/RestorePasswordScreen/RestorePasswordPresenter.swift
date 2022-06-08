//
//  RestorePasswordPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

protocol RestorePasswordPresenterProtocol {
}

final class RestorePasswordPresenter: RestorePasswordPresenterProtocol {
    
    private weak var viewController: RestorePasswordViewControllerProtocol!
    
    init(viewController: RestorePasswordViewControllerProtocol) {
        self.viewController = viewController
    }
}
