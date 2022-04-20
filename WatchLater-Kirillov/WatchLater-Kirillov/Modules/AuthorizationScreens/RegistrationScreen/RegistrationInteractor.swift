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
    
    // в сервис
    enum ResponseState {
        case success(Data?, Int)
        case failure(String)
    }
    
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
            switch status {
            case let .success(data, statusCode):
                self?.handleResponce(statusCode: statusCode, data: data)
            
            case .failure(let failDescription):
                print("RegistrationInteractor Network Error: \(failDescription)")
                self?.presenter.present(state: .networkFailure(Text.Authorization.somethingWentWrong))
            }
        }
    }
    
    private func handleResponce(statusCode: Int, data: Data?) {
        switch statusCode {
        case 200...201:
            // TODO: - If user registered then login him
            print("Need to login", statusCode)
        
        default:
            presenter.present(state: .registrationFailure(data, statusCode))
        }
    }
}
