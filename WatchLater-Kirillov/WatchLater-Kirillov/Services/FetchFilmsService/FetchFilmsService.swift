//
//  FetchFilmsService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/28/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

struct Status: Codable {
    let status: Bool
}

protocol FetchFilmsServiceProtocol {
    func fetchFilms(page: Int,
                    size: Int,
                    watched: Bool,
                    completion: @escaping (Result<[FilmData]?, Error>) -> Void)
    func changeFilmWatchStatus(id: Int,
                               completion: @escaping (Result<Bool, Error>) -> Void)
}

class FetchFilmsService: FetchFilmsServiceProtocol {
    
    private let userFilmsPath = "/users/films"
    private let filmsPath = "/films"
    
    private var baseURLComponents: URLComponents
    private let networkLayer: NetworkLayerProtocol
    
    init(networkLayer: NetworkLayerProtocol) {
        self.networkLayer = networkLayer
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = NetworkConfiguration.sceme
        baseURLComponents.host = NetworkConfiguration.urlString
    }
    
    func fetchFilms(page: Int,
                    size: Int,
                    watched: Bool,
                    completion: @escaping (Result<[FilmData]?, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "watched", value: watched ? "true" : "false")
        ]
        var urlComponents = baseURLComponents
        urlComponents.path = userFilmsPath
        urlComponents.queryItems = queryItems
        guard let request = buildRequest(url: urlComponents.url!,
                                         method: HTTPMethod.get)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        networkLayer.request(urlRequest: request) { [weak self] data, response, error in
            guard let responsHTTP = response as? HTTPURLResponse,
                  error == nil,
                  let data = data
            else {
                if let error = error {
                    completion(.failure(error))
                } else if data == nil {
                    completion(.failure(BaseError.noData))
                } else {
                    completion(.failure(BaseError.noResponse))
                }
                return
            }
            self!.handleResponse(data: data,
                                 status: responsHTTP.statusCode,
                                 completion: completion)
        }
    }
    
    func postFilmData() {
    }
    
    func changeFilmWatchStatus(id: Int,
                               completion: @escaping (Result<Bool, Error>) -> Void) {
        var urlComponents = baseURLComponents
        urlComponents.path = userFilmsPath + "/\(id)"
        guard let request = buildRequest(url: urlComponents.url!,
                                         method: HTTPMethod.put)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        networkLayer.request(urlRequest: request) { data, response, error in
            guard error == nil,
                  let responsHTTP = response as? HTTPURLResponse,
                  responsHTTP.statusCode == 200
            else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(BaseError.range400Response))
                }
                return
            }
            guard let filmsInfo = decodeMessage(data: data, type: Status.self)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            if filmsInfo.status {
                completion(.success(filmsInfo.status))
            } else {
                completion(.failure(BaseError.badResult))
            }
        }
    }
    
    private func handleResponse(data: Data,
                                status: Int,
                                completion: @escaping (Result<[FilmData]?, Error>) -> Void) {
        switch status {
        case 200:
            guard let filmsInfo = decodeMessage(data: data, type: FilmsList.self)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            completion(.success(filmsInfo.filmDtos))

        default:
            completion(.failure(BaseError.range400Response))
        }
    }
    
    private func buildRequest(url: URL, method: HTTPMethod) -> RequestBuilder? {
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
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
