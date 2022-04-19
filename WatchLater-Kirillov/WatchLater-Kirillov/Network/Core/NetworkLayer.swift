//
//  NetworkLayer.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/18/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

extension URLRequestBuilder {

    func asURLRequest() throws -> URLRequest {
        return urlRequest
    }
}

protocol URLRequestBuilder: URLRequestConvertible {
    var urlRequest: URLRequest { get }
}

protocol NetworkLayerProtocol {
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
    func cancel(by url: URL)
}

final class NetworkLayer: NetworkLayerProtocol {
    
    private let session: Session
    
    init(sessionConfig: URLSessionConfiguration = AF.sessionConfiguration) {
        session = Session(configuration: sessionConfig)
    }
    
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        let request = session.request(urlRequest)
        completion(request.data,
                   request.response,
                   request.error)
    }
    
    func cancel(by url: URL) {
        session.cancelAllRequests(completingOnQueue: .main)
    }
}
