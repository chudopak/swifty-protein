//
//  SplashPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit

protocol SplashPresenterProtocol {
    func proceedTokenValidationState(result: RefreshResult)
    func proceedTokenRecreationState(result: RefreshResult)
}

final class SplashPresenter: SplashPresenterProtocol {
    
    private weak var viewController: SplashViewControllerProtocol!
    
    init(viewController: SplashViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func proceedTokenValidationState(result: RefreshResult) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.handleTokenValidating(result: result)
        }
    }
    
    func proceedTokenRecreationState(result: RefreshResult) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.handleTokenRefreeshing(result: result)
        }
    }
}
