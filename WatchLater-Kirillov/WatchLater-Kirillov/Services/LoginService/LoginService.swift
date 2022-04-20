//
//  LoginService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/18/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol LoginServiceProtocol {
    func login(with data: LoginData,
               completion: @escaping (LoginResponseState) -> Void)
}

final class LoginService: LoginServiceProtocol {
    
    let loginPath = "/auth/login"
    
    private let networklayer: NetworkLayerProtocol
    
    private var request: RequestBuilder
    
    init?(networkLayer: NetworkLayerProtocol, httpBody: Data? = nil) {
        self.networklayer = networkLayer
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.urlString
        urlComponents.path = loginPath
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
    
    func login(with data: LoginData, completion: @escaping (LoginResponseState) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(Text.Authorization.somethingWentWrong, nil))
        }
        networklayer.request(urlRequest: request) { [weak self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  error == nil
            else {
                if let error = error {
                    completion(.failure(Text.Authorization.somethingWentWrong, error))
                } else {
                    completion(.failure(Text.Authorization.somethingWentWrong, nil))
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
                                completion: @escaping (LoginResponseState) -> Void) {
        switch statusCode {
        case 200...201:
            if let tokens = decodeMessage(data: data, type: Tokens.self) {
                print(tokens)
            } else {
                print("Can't Decode tokens")
            }
            
        case 400:
            print("Email doesn't registered")
            
        case 401:
            print("Passwords doesn't match")
            
        default:
            print("Unowend error")
        }
    }
    
    private func decodeMessage<T: Codable>(data: Data?, type: T.Type) -> T? {
        guard let data = data,
              let decoded = try? JSONDecoder().decode(type.self, from: data)
        else {
            return nil
        }
        return decoded
    }
}
