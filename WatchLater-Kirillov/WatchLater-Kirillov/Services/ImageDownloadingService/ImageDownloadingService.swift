//
//  ImageDownloadingService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol ImageDownloadingServiceProtocol {
    func download(id: String,
                  completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
    func removeImageFromCache(id: String)
}

// TODO: - it doesn't work because of multithreading
final class ImageDownloadingService: ImageDownloadingServiceProtocol {
    
    private let networkManager: NetworkLayerProtocol
    
    private let path = "/poster/"
    
    private var baseURLComponents: URLComponents
    
    private let imageCache = ImageCache()
    
    init(networkManager: NetworkLayerProtocol) {
        self.networkManager = networkManager
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = NetworkConfiguration.sceme
        baseURLComponents.host = NetworkConfiguration.urlString
    }
    
    func download(id: String,
                  completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        if let image = imageCache.getImageFromCache(id: id) {
            print("GOT FROM CAHCE ID - \(id)")
            completion(.success((id, image)))
            return
        }
        var urlComponents = baseURLComponents
        let finalPath = path + id
        urlComponents.path = finalPath
        guard let request = buildRequest(url: urlComponents.url!)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        self.fetchImage(id: id, urlRequest: request, completion: completion)
    }
    
    func removeImageFromCache(id: String) {
    }
    
    private func fetchImage(id: String,
                            urlRequest: RequestBuilder,
                            completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        networkManager.request(urlRequest: urlRequest) { [weak self] data, response, error in
            guard error == nil,
                  let responseHTTP = response as? HTTPURLResponse,
                  responseHTTP.statusCode == 200,
                  let data = data
            else {
                if let error = error {
                    completion(.failure(error))
                } else if data == nil {
                    completion(.failure(BaseError.noData))
                } else {
                    completion(.failure(BaseError.range400Response))
                }
                return
            }
            guard let imageDataJSON = decodeMessage(data: data, type: ImageData.self),
                  let image = UIImage(data: imageDataJSON.data)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            self?.imageCache.storeImage(imageId: id, image: image)
            completion(.success((id, image)))
        }
    }
    
    private func buildRequest(url: URL) -> RequestBuilder? {
        var urlRequest = URLRequest(url: url)
        urlRequest.method = HTTPMethod.get
        urlRequest.setValue(NetworkConfiguration.Headers.contentTypeJSON.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.contentTypeJSON.field)
        urlRequest.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)
        guard let accessToken = KeychainService.getString(key: .accessToken)
        else {
            return nil
        }
        urlRequest.setValue(accessToken,
                            forHTTPHeaderField: NetworkConfiguration.Headers.authorisation)
        return RequestBuilder(urlRequest: urlRequest)
    }
}
