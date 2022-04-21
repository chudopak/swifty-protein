//
//  RefreshTokenService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol RefreshTokenServiceProtocol {
    func refresh(completion: @escaping (RefreshResult) -> Void)
    func validateToken(completion: @escaping (RefreshResult) -> Void)
}

final class RefreshTokenService: RefreshTokenServiceProtocol {
    
    private let testPath = "/users/profile"
    private let refreshPath = "/auth/token"
    
    private let networklayer: NetworkLayerProtocol
    
    private var validateRequest: RequestBuilder
    private var refreshRequest: RequestBuilder
    
    init(networkLayer: NetworkLayerProtocol, httpBody: Data? = nil) {
        self.networklayer = networkLayer
        self.refreshRequest = RequestBuilder(urlRequest: URLRequest(url: NetworkConfiguration.url))
        self.validateRequest = RequestBuilder(urlRequest: URLRequest(url: NetworkConfiguration.url))
        self.validateRequest = buildTestRequest()
        self.refreshRequest = buildRefreshRequest()
    }
    
    func refresh(completion: @escaping (RefreshResult) -> Void) {
        guard let tokens = getTokens()
        else {
            completion(.failure)
            return
        }
        refreshRequest.urlRequest.setValue(tokens.accessToken,
                                           forHTTPHeaderField: NetworkConfiguration.Headers.authorisation)
        do {
            let jsonData = try JSONEncoder().encode(tokens.refreshToken)
            refreshRequest.urlRequest.httpBody = jsonData
        } catch {
            completion(.failure)
        }
        networklayer.request(urlRequest: validateRequest) { [weak self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  error == nil
            else {
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure)
                } else {
                    completion(.failure)
                }
                return
            }
            self!.handleRefreshRequest(data: data,
                                       statusCode: responsHTTP.statusCode,
                                       completion: completion)
        }
    }
    
    func validateToken(completion: @escaping (RefreshResult) -> Void) {
        guard let tokens = getTokens()
        else {
            completion(.failure)
            return
        }
        validateRequest.urlRequest.setValue(tokens.accessToken,
                                            forHTTPHeaderField: NetworkConfiguration.Headers.authorisation)
        networklayer.request(urlRequest: validateRequest) { [weak self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  error == nil
            else {
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure)
                } else {
                    completion(.failure)
                }
                return
            }
            self!.handleValidateRequest(statusCode: responsHTTP.statusCode,
                                        completion: completion)
        }
    }
    
    private func handleValidateRequest(statusCode: Int,
                                       completion: @escaping (RefreshResult) -> Void) {
        switch statusCode {
        case 200...201:
            completion(.success)

        default:
            completion(.failure)
        }
    }
    
    private func handleRefreshRequest(data: Data?,
                                      statusCode: Int,
                                      completion: @escaping (RefreshResult) -> Void) {
        switch statusCode {
        case 200...201:
            guard let tokens = decodeMessage(data: data, type: Tokens.self)
            else {
                print("RefreshTokenService: - Can't Decode tokens")
                completion(.failure)
                return
            }
            guard KeychainService.set(data: tokens.accessToken, key: .accessToken),
                  KeychainService.set(data: tokens.refreshToken, key: .refreshToken)
            else {
                print("RefreshTokenService: - Can't save tokens to keychain")
                completion(.failure)
                return
            }
            print(KeychainService.getString(key: .accessToken)!)
            print(KeychainService.getString(key: .refreshToken)!)
            completion(.success)

        default:
            completion(.failure)
        }
    }
    
    private func buildTestRequest() -> RequestBuilder {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.urlString
        urlComponents.path = testPath
        var request = RequestBuilder(urlRequest: URLRequest(url: urlComponents.url!))
        request.urlRequest.method = HTTPMethod.get
        request.urlRequest.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                                    forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)
        return request
    }
    
    private func buildRefreshRequest() -> RequestBuilder {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.urlString
        urlComponents.path = refreshPath
        var request = RequestBuilder(urlRequest: URLRequest(url: urlComponents.url!))
        request.urlRequest.method = HTTPMethod.post
        request.urlRequest.setValue(NetworkConfiguration.Headers.contentTypeJSON.value,
                                    forHTTPHeaderField: NetworkConfiguration.Headers.contentTypeJSON.field)
        request.urlRequest.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                                    forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)

        return request
    }
    
    private func getTokens() -> Tokens? {
        guard let accessToken = KeychainService.getString(key: .accessToken),
              let refreshToken = KeychainService.getString(key: .refreshToken)
        else {
            return nil
        }
        return (Tokens(accessToken: accessToken, refreshToken: refreshToken))
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
