//
//  NetworkLayer.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import Alamofire
import UIKit

protocol NetworkLayerProtocol {
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func request(url: URL,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel(by url: URL,
                completion: @escaping () -> Void)
    func cancelAll(completion: @escaping () -> Void)
}

final class NetworkLayer: NetworkLayerProtocol {
    
    private let session: Session
    
    init(sessionConfig: URLSessionConfiguration = AF.sessionConfiguration) {
        session = Session(configuration: sessionConfig)
    }
    
    func request(urlRequest: URLRequestBuilder,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.request(urlRequest).response { data in
            completion(data.data, data.response, data.error)
        }
    }
    
    func request(url: URL,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.request(url).response { data in
            completion(data.data, data.response, data.error)
        }
    }
    
    func cancel(by url: URL,
                completion: @escaping () -> Void) {
        session.session.getTasksWithCompletionHandler { dataTask, uploadTask, downloadTask in
            dataTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == url.absoluteString {
                    task.cancel()
                }
            }
            uploadTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == url.absoluteString {
                    task.cancel()
                }
            }
            downloadTask.forEach { task in
                if task.originalRequest?.url?.absoluteString == url.absoluteString {
                    task.cancel()
                }
            }
            completion()
        }
    }
    
    func cancelAll(completion: @escaping () -> Void) {
        session.cancelAllRequests {
            completion()
        }
    }
}
