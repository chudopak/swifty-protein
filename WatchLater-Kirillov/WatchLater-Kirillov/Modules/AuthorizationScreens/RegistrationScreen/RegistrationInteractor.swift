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
    
    private let presenter: RegistrationPresenter
    private let networkService: RegistrationServiceProtocol
    
    init(presenter: RegistrationPresenter, networkService: RegistrationServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func register(data: RegistrationData) {
        networkService.register(with: data) { [weak self] status in
            self?.presenter.proceedRegistrationResult(state: status)
        }
    }
}
