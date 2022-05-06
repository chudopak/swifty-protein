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
    func downloadData(id: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
    func downloadJPEG(urlString: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
    func removeImageFromCache(id: String) -> Bool
    func removeAllImages() -> Bool
}

// TODO: - May be cash in memory images and in storage (now only in storage)
final class ImageDownloadingService: ImageDownloadingServiceProtocol {
    
    private let networkManager: NetworkLayerProtocol
    
    private let path = "/poster/"
    
    private var baseURLComponents: URLComponents
    
    private let imageCache = MoviesImageCache()
    
    init(networkManager: NetworkLayerProtocol) {
        self.networkManager = networkManager
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = NetworkConfiguration.sceme
        baseURLComponents.host = NetworkConfiguration.urlString
    }
    
    func downloadData(id: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let image = self?.imageCache.getImageFromCache(id: id) {
                completion(.success((id, image)))
                return
            }
            guard var urlComponents = self?.baseURLComponents,
                  let pathTmp = self?.path
            else {
                completion(.failure(BaseError.failedToBuildRequest))
                return
            }

            let finalPath = pathTmp + id
            urlComponents.path = finalPath
            guard let url = urlComponents.url,
                  let request = self?.buildRequest(url: url)
            else {
                completion(.failure(BaseError.failedToBuildRequest))
                return
            }
            self?.fetchImage(id: id, urlRequest: request, completion: completion)
        }
    }
    
    func downloadJPEG(urlString: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        guard let url = URL(string: urlString)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        networkManager.request(url: url) { data, response, error in
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
            guard let image = UIImage(data: data)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            completion(.success((urlString, image)))
        }
    }
    
    func removeImageFromCache(id: String) -> Bool {
        let url = imageCache.imageCacheDir.appendingPathComponent(id)
        return imageCache.deletePoster(url: url)
    }
    
    // TODO: - i think it is better to delete in background
    func removeAllImages() -> Bool {
        return imageCache.deleteCacheDirectory()
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
            let savingResult = self?.imageCache.storeImage(imageId: id, image: image)
            if savingResult == nil || !savingResult! {
                print("Failed to save poster with id - \(id)")
            }
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
