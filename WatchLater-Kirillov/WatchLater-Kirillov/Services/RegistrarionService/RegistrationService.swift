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
                  completion: @escaping (RegistrationInteractor.ResponseState) -> Void)
}

final class RegistrationService: RegistrationServiceProtocol, URLRequestBuilder {
    
    let path = "/users"
    
    var urlRequest: URLRequest {
        return request
    }
    
    private let networklayer = NetworkLayer()
    
    private var request: URLRequest!
    
    init?(httpBody: Data? = nil) {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.urlString
        urlComponents.path = path
        guard let url = urlComponents.url else {
            return nil
        }
        request = URLRequest(url: url)
        request.method = HTTPMethod.post
        request.setValue(NetworkConfiguration.Headers.contentTypeJSON.value,
                         forHTTPHeaderField: NetworkConfiguration.Headers.contentTypeJSON.field)
        request.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                         forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)
        request.httpBody = httpBody
    }
    
    func register(with data: RegistrationData,
                  completion: @escaping (RegistrationInteractor.ResponseState) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure("Can't decode RegistrationData in RegistrationService to JSON"))
        }
        networklayer.request(urlRequest: self) { data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                    error == nil
            else {
                if let error = error {
                    completion(.failure(error.localizedDescription))
                } else {
                    completion(.failure("Can't cast URLResponse to HTTPURLResponse and get statusCode"))
                }
                return
            }
            // TODO: - parse data here
            completion(.success(data, responsHTTP.statusCode))
        }
    }
}
