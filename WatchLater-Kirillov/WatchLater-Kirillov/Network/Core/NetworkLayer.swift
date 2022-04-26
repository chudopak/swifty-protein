//
//  NetworkLayer.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/18/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol NetworkLayerProtocol {
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func request(url: URL,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel(by url: URL)
}

// TODO: - Протестировать что будет если не действителен токен (на лики тести)
final class NetworkLayer: NetworkLayerProtocol {
    
    private let session: Session
    
    private let refreshService: RefreshTokenServiceProtocol
    
    init(refreshService: RefreshTokenServiceProtocol, sessionConfig: URLSessionConfiguration = AF.sessionConfiguration) {
        self.refreshService = refreshService
        session = Session(configuration: sessionConfig)
    }
    
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        AF.request(urlRequest).response { [weak self] data in
            if let response = data.response, response.statusCode == 401 {
                self?.refreshService.refresh { result in
                    switch result {
                    case .success:
                        self?.request(urlRequest: urlRequest, completion: completion)
                        
                    case .failure:
                        self?.deleteTokensData()
                        DispatchQueue.main.async {
                            UIWindowService.replaceRootViewController(with: LoginControllerConfigurator().setupModule())
                        }
                    }
                }
            } else {
                completion(data.data, data.response, data.error)
            }
        }
    }
    
    func request(url: URL,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        AF.request(url).response { [weak self] data in
            if let response = data.response, response.statusCode == 401 {
                self?.refreshService.refresh { result in
                    switch result {
                    case .success:
                        self?.request(url: url, completion: completion)
                        
                    case .failure:
                        self?.deleteTokensData()
                        DispatchQueue.main.async {
                            UIWindowService.replaceRootViewController(with: LoginControllerConfigurator().setupModule())
                        }
                    }
                }
            } else {
                completion(data.data, data.response, data.error)
            }
        }
    }
    
    func cancel(by url: URL) {
        session.cancelAllRequests(completingOnQueue: .main)
    }
    
    private func deleteTokensData() {
        
        guard KeychainService.delete(key: .accessToken),
              KeychainService.delete(key: .refreshToken)
        else {
            print("NetworkLayer - can't delete Tokens from keychain")
            return
        }
    }
}
