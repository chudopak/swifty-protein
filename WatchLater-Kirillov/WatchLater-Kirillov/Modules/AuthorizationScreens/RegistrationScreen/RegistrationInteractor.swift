//
//  RegistrationInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol RegistrationInteractorProtocol {
    func register(data: RegistrationData)
}

class RegistrationInteractor: RegistrationInteractorProtocol {
    
    private let presenter: RegistrationPresenterProtocol
    private let networkService: RegistrationServiceProtocol
    
    init(presenter: RegistrationPresenterProtocol, networkService: RegistrationServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func register(data: RegistrationData) {
        guard !data.email.isEmpty && !data.password.isEmpty && !data.repeatPassword.isEmpty
        else {
            presenter.showFailedState(message: Text.Authorization.fieldsMustBeFilled)
            return
        }
        guard data.password == data.repeatPassword
        else {
            presenter.showFailedState(message: Text.Authorization.passwordsNotMatch)
            return
        }
        networkService.register(with: data) { [weak self] status in
            self?.presenter.proceedRegistrationResult(state: status)
        }
    }
}
