//
//  ImageDownloadingService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

protocol ImageDownloadingServiceProtocol {
    func downloadData(id: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
    func downloadJPEG(urlString: String,
                      completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
    func downloadWithKingFisher(url: URL, imageView: UIImageView)
    func removeImageFromCache(id: String) -> Bool
    func removeAllImages() -> Bool
    func clearKingFisherCache()
}

protocol ProfileImageloadingProtocol {
    func uploadImage(data: Data,
                     completion: @escaping (Result<String, Error>) -> Void)
    func getProfilePhoto(completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void)
}

// TODO: - May be cash in memory images and in storage (now only in storage)
final class ImageDownloadingService: ImageDownloadingServiceProtocol {
    
    private let networkManager: NetworkLayerProtocol
    
    private let path = "/poster/"
    private let profileImageUploadPath = "/users/photo"
    private let profileImageDownloadPath = "/users/profile/photo"
    
    private var baseURLComponents: URLComponents
    
    private let imageCache = MoviesImageCache()
    
    init(networkManager: NetworkLayerProtocol) {
        self.networkManager = networkManager
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = NetworkConfiguration.sceme
        baseURLComponents.host = NetworkConfiguration.urlString
    }
    
    func downloadWithKingFisher(url: URL, imageView: UIImageView) {
        let prosessor = ResizingImageProcessor(
            referenceSize: CGSize(width: SearchScreenSizes.TableView.posterImageViewWidth,
                                  height: SearchScreenSizes.TableView.posterImageViewHeight))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.processor(prosessor)])
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
        networkManager.request(url: url) { [weak self] data, response, error in
            guard let data = self?.validateResponse(data: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
            else {
                return
            }
            guard let image = UIImage(data: data)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            guard let compressedImage = self?.compressImage(image: image, compressionQuality: 0.5)
            else {
                completion(.success((urlString, image)))
                return
            }
            completion(.success((urlString, compressedImage)))
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
    
    func clearKingFisherCache() {
        ImageCache.default.clearMemoryCache()
    }
    
    private func fetchImage(id: String,
                            urlRequest: RequestBuilder,
                            completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        networkManager.request(urlRequest: urlRequest) { [weak self] data, response, error in
            guard let data = self?.validateResponse(data: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
            else {
                return
            }
            guard let imageDataJSON = decodeMessage(data: data, type: ImageData.self),
                  let image = UIImage(data: imageDataJSON.data)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            let compressedImage = self?.compressImage(image: image, compressionQuality: 0.5)
            let newImage = compressedImage == nil ? image : compressedImage!
            if let savingResult = self?.imageCache.storeImage(imageId: id, image: newImage), !savingResult {
                print("Failed to save poster with id - \(id)")
            }
            completion(.success((id, newImage)))
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
    
    private func compressImage(image: UIImage,
                               compressionQuality: CGFloat) -> UIImage? {
        guard let data = image.jpegData(compressionQuality: compressionQuality),
              let compressedImage = UIImage(data: data)
        else {
            return nil
        }
        return (compressedImage)
    }
    
    private func validateResponse<T>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Data? {
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
            return nil
        }
        return data
    }
}

// TODO: post image doesn't work
extension ImageDownloadingService: ProfileImageloadingProtocol {

    func uploadImage(data: Data,
                     completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = baseURLComponents
        urlComponents.path = profileImageUploadPath

        guard let url = urlComponents.url,
              let request = buildRequestMultipartData(url: url, imageData: data)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        fetchImage(urlRequest: request, completion: completion)
    }
    
    func getProfilePhoto(completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        var urlComponents = baseURLComponents
        urlComponents.path = profileImageDownloadPath
        guard let url = urlComponents.url,
              let request = buildRequest(url: url)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        fetchImage(urlRequest: request, completion: completion)
    }
    
    private func fetchImage(urlRequest: RequestBuilder,
                            completion: @escaping (Result<(id: String, image: UIImage), Error>) -> Void) {
        networkManager.request(urlRequest: urlRequest) { [weak self] data, response, error in
            guard let data = self?.validateResponse(data: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
            else {
                return
            }
            guard let imageDataJSON = decodeMessage(data: data, type: ProfileImageData.self),
                  let image = UIImage(data: imageDataJSON.image.data)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            completion(.success((imageDataJSON.id, image)))
        }
    }
    
    private func fetchImage(urlRequest: RequestBuilder,
                            completion: @escaping (Result<String, Error>) -> Void) {
        networkManager.request(urlRequest: urlRequest) { [weak self] data, response, error in
            guard let data = self?.validateResponse(data: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
            else {
                return
            }
            guard let posterIDOptional = decodeMessage(data: data, type: UserInfoBackground.self),
                  let posterId = posterIDOptional.photoId
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            completion(.success(posterId))
        }
    }
    
    // TODO: find the way how to make right request
    private func buildRequestMultipartData(url: URL, imageData: Data) -> RequestBuilder? {
        guard let accessToken = KeychainService.getString(key: .accessToken)
        else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
//        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.method = HTTPMethod.post
        urlRequest.setValue(NetworkConfiguration.Headers.acceptEverything.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.acceptEverything.field)
        urlRequest.setValue(accessToken,
                            forHTTPHeaderField: NetworkConfiguration.Headers.authorisation)
        urlRequest.setValue(NetworkConfiguration.Headers.multipartData.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.multipartData.field)
        var body = Data()
        guard let contentType = "image=@Screenshot 2021-07-30 at 6.12.20 PM.jpg;type=image/jpeg".data(using: .utf8)
//                  guard let contentDisposition = "Content-Disposition: form-data; filename=\"\(UUID().uuidString)\"\r\n".data(using: .utf8),
//              let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8),
//              let newLine = "\r\n".data(using: .utf8)
        else {
            return nil
        }
//        body.append(boundaryPrefix)
//        body.append(contentDisposition)
        body.append(contentType)
        body.append(imageData)
//        body.append(newLine)
        
        urlRequest.httpBody = body
        return RequestBuilder(urlRequest: urlRequest)
    }
}
