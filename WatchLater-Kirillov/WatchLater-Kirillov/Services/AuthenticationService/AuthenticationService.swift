//
//  AuthenticationService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/18/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class AuthenticationService: URLRequestBuilder {
    
    enum AuthenticationCase {
        case login(Data?)
        case token(Data?)
    }
    
    var urlRequest: URLRequest {
        return request
    }
    
    private let networklayer = NetworkLayer()
    
    private var request: URLRequest!
    
    init?(authCase: AuthenticationCase) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Text.Api.sceme
        urlComponents.host = Text.Api.host
        urlComponents.path = getPath(authCase)
        guard let url = urlComponents.url else {
            return nil
        }
        request = URLRequest(url: url)
        request.httpBody = getBody(authCase)
    }
    
    func request(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        networklayer.request(urlRequest: self,
                             completion: completion)
    }

    private func getPath(_ authCase: AuthenticationCase) -> String {
        switch authCase {
        case .login:
            return Text.Api.AuthController.login
        
        case .token:
            return Text.Api.AuthController.token
        }
    }
    
    private func getBody(_ authCase: AuthenticationCase) -> Data? {
        switch authCase {
        case .login(let body):
            return body

        case .token(let body):
            return body
        }
    }
}
