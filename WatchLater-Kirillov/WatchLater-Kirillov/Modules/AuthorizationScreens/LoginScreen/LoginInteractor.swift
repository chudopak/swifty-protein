//
//  LoginInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol LoginInteractorProtocol {
    func login(data: LoginData)
}

final class LoginInteractor: LoginInteractorProtocol {
    
    private let presenter: LoginPresenterProtocol
    private let networkService: LoginServiceProtocol
    
    init(presenter: LoginPresenterProtocol, networkService: LoginServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func login(data: LoginData) {
        if data.email.isEmpty || data.password.isEmpty {
            presenter.failedToLogin(message: Text.Authorization.fieldsMustBeFilled)
            return
        }
        networkService.login(with: data) { [weak self] status in
            self?.presenter.procedLoginResult(state: status)
        }
    }
}
