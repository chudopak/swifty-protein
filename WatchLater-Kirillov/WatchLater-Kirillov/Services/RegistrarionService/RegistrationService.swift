//
//  RegistrationService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/19/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class RegistrationService: URLRequestBuilder {
    
    var urlRequest: URLRequest {
        return request
    }
    
    private let networklayer = NetworkLayer()
    
    private var request: URLRequest!
    
    init?(httpBody: Data?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Text.Api.sceme
        urlComponents.host = Text.Api.host
        urlComponents.path = Text.Api.UserController.register
        guard let url = urlComponents.url else {
            return nil
        }
        request = URLRequest(url: url)
        request.httpBody = httpBody
    }
    
    func request(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        networklayer.request(urlRequest: self,
                             completion: completion)
    }
}
