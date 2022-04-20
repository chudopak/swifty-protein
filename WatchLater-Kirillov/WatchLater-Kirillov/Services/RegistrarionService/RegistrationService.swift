//
//  RegistrationService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol RegistrationServiceProtocol {
    func register(with data: RegistrationData,
                  completion: @escaping (RegistrationResponseState) -> Void)
}

final class RegistrationService: RegistrationServiceProtocol {
    
    let path = "/users"
    
    private let networklayer = NetworkLayer()
    
    private var request: RequestBuilder
    
    init?(httpBody: Data? = nil) {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.urlString
        urlComponents.path = path
        guard let url = urlComponents.url else {
            return nil
        }
        request = RequestBuilder(urlRequest: URLRequest(url: url))
        request.urlRequest.method = HTTPMethod.post
        request.urlRequest.setValue(NetworkConfiguration.Headers.contentTypeJSON.value,
                                    forHTTPHeaderField: NetworkConfiguration.Headers.contentTypeJSON.field)
        request.urlRequest.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                                    forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)
        request.urlRequest.httpBody = httpBody
    }
    
    func register(with data: RegistrationData,
                  completion: @escaping (RegistrationResponseState) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(Text.Authorization.somethingWentWrong, RError.unowned))
        }
        networklayer.request(urlRequest: request) { [weak self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  error == nil
            else {
                if let error = error {
                    completion(.failure(Text.Authorization.somethingWentWrong, error))
                } else {
                    completion(.failure(Text.Authorization.somethingWentWrong, RError.unowned))
                }
                return
            }
            self?.handleResponse(data: data,
                                 statusCode: responsHTTP.statusCode,
                                 completion: completion)
        }
    }
    
    private func handleResponse(data: Data?,
                                statusCode: Int,
                                completion: @escaping (RegistrationResponseState) -> Void) {
        switch statusCode {
        case 200...201:
            // TODO: - If user registered then login him
            print("Need to login", statusCode)
            
        case 400:
            completion(.failure(getErrorDescriptionMessage(data: data), RError.badEmailFormat))
            
        case 401:
            completion(.failure(getErrorDescriptionMessage(data: data), RError.alreadyExist))
            
        default:
            completion(.failure(Text.Authorization.somethingWentWrong, RError.unowned))
        }
    }
    
    private func getErrorDescriptionMessage(data: Data?) -> String {
        guard let data = data,
              let errorDescription = try? JSONDecoder().decode(RegistrationError.self, from: data)
        else {
            return Text.Authorization.somethingWentWrong
        }
        return errorDescription.message
    }
}
