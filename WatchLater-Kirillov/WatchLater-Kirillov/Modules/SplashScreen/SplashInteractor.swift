//
//  SplashInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit

protocol SplashInteractorProtocol {
    func validateToken()
    func recreateToken()
}

final class SplashInteractor: SplashInteractorProtocol {
    
    private let presenter: SplashPresenterProtocol
    private let refreshTokenService: RefreshTokenServiceProtocol
    
    init(presenter: SplashPresenterProtocol,
         refreshTokenService: RefreshTokenServiceProtocol) {
        self.presenter = presenter
        self.refreshTokenService = refreshTokenService
    }
    
    func validateToken() {
        refreshTokenService.validateToken { [weak self] state in
            self?.presenter.proceedTokenValidationState(result: state)
        }
    }
    
    func recreateToken() {
        refreshTokenService.refresh { [weak self] state in
            self?.presenter.proceedTokenRecreationState(result: state)
        }
    }
      
}
