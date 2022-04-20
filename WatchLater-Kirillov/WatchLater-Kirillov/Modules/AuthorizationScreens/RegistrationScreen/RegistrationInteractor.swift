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
    private let registrationNetworkService: RegistrationServiceProtocol
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        if let registration = RegistrationService() {
            registrationNetworkService = registration
        } else {
            fatalError("Can't create registration URL")
        }
    }
    
    func register(data: RegistrationData) {
        registrationNetworkService.register(with: data) { [weak self] status in
            self?.presenter.proceedRegistrationResult(state: status)
        }
    }
}
