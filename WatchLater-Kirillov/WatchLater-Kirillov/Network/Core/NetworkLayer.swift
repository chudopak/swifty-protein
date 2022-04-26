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

// TODO: - От слеживать статус код 401 и сразу обновить токен
final class NetworkLayer: NetworkLayerProtocol {
    
    private let session: Session
    
    init(sessionConfig: URLSessionConfiguration = AF.sessionConfiguration) {
        session = Session(configuration: sessionConfig)
    }
    
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        AF.request(urlRequest).response { data in
            completion(data.data, data.response, data.error)
        }
    }
    
    func request(url: URL,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        AF.request(url).response { data in
            completion(data.data, data.response, data.error)
        }
    }
    
    func cancel(by url: URL) {
        session.cancelAllRequests(completingOnQueue: .main)
    }
}
