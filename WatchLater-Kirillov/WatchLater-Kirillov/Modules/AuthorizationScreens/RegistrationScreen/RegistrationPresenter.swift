//
//  RegistrationPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class RegistrationPresenter {
    
    enum RegistrationState {
        case success(Data?, Int)
        case registrationFailure(Data?, Int)
        case networkFailure(String)
    }

    weak var registrationViewController: RegistrationViewController!
    
    func present(state: RegistrationState) {
        switch state {
        case let .success(data, statusCode):
            // TODO: - Call method that will present User
            print("Presenter success", data ?? "", statusCode)

        case let .registrationFailure(data, statusCode):
            handleRegistrationFailureResponse(data: data, statusCode: statusCode)

        case .networkFailure(let displayMessage):
            handleNetworkFailureResponse(displayMessage: displayMessage)
        }
    }
    
    private func handleNetworkFailureResponse(displayMessage: String) {
        registrationViewController.registrationFailedState(displayMessage: displayMessage)
    }
    
    private func handleRegistrationFailureResponse(data: Data?, statusCode: Int) {
        switch statusCode {
        case 400...401:
            guard let data = data,
                  let errorDescription = try? JSONDecoder().decode(RegistrationError.self, from: data)
            else {
                registrationViewController.registrationFailedState(displayMessage: Text.Authorization.somethingWentWrong)
                return
            }
            registrationViewController.registrationFailedState(displayMessage: errorDescription.message)
        
        default:
            registrationViewController.registrationFailedState(displayMessage: Text.Authorization.somethingWentWrong)
        }
    }
}
