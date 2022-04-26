//
//  ImageDownloadingService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageDownloadingServiceProtocol {
    func download(id: String,
                  url: URL,
                  completion: @escaping (Result<UIImage?, Error>) -> Void)
    func removeImageFromCache(id: String)
}

// TODO: - it doesn't work because of multithreading
final class ImageDownloadingService: ImageDownloadingServiceProtocol {
    
    private let cache: ImageCache
    private let networkManager: NetworkLayerProtocol
    private let semaphoreCache = DispatchSemaphore(value: 1)
    
    init(cacheConfig: ImageCache, networkManager: NetworkLayerProtocol) {
        cache = cacheConfig
        self.networkManager = networkManager
    }
    
    func download(id: String,
                  url: URL,
                  completion: @escaping (Result<UIImage?, Error>) -> Void) {
        if cache.isCached(forKey: id) {
            cache.retrieveImage(forKey: "cacheKey") { [unowned self] result in
                
                switch result {
                case .success(let value):
                    guard let image = value.image
                    else {
                        self.removeImageFromCache(id: id)
                        print("get from cache")
                        self.fetchImage(id: id, url: url, completion: completion)
                        return
                    }
                    completion(.success(image))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            print("downloaded")
            self.fetchImage(id: id, url: url, completion: completion)
        }
    }
    
    func removeImageFromCache(id: String) {
        self.semaphoreCache.wait()
        cache.removeImage(forKey: id)
        self.semaphoreCache.signal()
    }
    
    private func fetchImage(id: String,
                            url: URL,
                            completion: @escaping (Result<UIImage?, Error>) -> Void) {
        networkManager.request(url: url) { [unowned self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  (200...299).contains(responsHTTP.statusCode),
                  error == nil,
                  let data = data,
                  let image = KFCrossPlatformImage(data: data)
            else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(BaseError.noResponse))
                }
                return
            }
            DispatchQueue.main.async {
                self.handleImageCaching(id: id, image: image, imageData: data)
            }
            completion(.success(image))
        }
    }
    
    private func handleImageCaching(id: String, image: KFCrossPlatformImage, imageData: Data? = nil) {
        self.semaphoreCache.wait()
        if let imageData = imageData {
            cache.store(image, original: imageData, forKey: id)
        } else {
            cache.store(image, forKey: id)
        }
        self.semaphoreCache.signal()
    }
}
