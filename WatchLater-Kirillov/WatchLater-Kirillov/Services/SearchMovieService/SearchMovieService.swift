//
//  SearchMovieService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchMovieServiceProtocol {
    func searchMovies(expression: String,
                      completion: @escaping (Result<[MovieData], Error>) -> Void)
    func cancelPreviousRequest(expression: String,
                               completion: @escaping () -> Void)
    func cancelAllTasks(completion: @escaping () -> Void)
}

class SearchMovieService: SearchMovieServiceProtocol {
    
    private let path = "/API/SearchMovie/\(IMDBNetworkConfiguration.APIKey)/"
    
    private var baseURLComponents: URLComponents
    
    private let networkManager: NetworkLayerProtocol
    
    init(networkManager: NetworkLayerProtocol) {
        self.networkManager = networkManager
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = IMDBNetworkConfiguration.sceme
        baseURLComponents.host = IMDBNetworkConfiguration.urlString
    }
    
    func searchMovies(expression: String,
                      completion: @escaping (Result<[MovieData], Error>) -> Void) {
        guard let request = buildRequest(expression: expression)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        print(request.urlRequest.url!)
        makeRequest(request: request,
                    completion: completion)
    }
    
    func cancelPreviousRequest(expression: String,
                               completion: @escaping () -> Void) {
        guard let request = buildRequest(expression: expression),
              let url = request.urlRequest.url
        else {
            print("SearchMovieService,cancelPreviousRequest - Can't build request")
            return
        }
        networkManager.cancel(by: url, completion: completion)
    }
    
    func cancelAllTasks(completion: @escaping () -> Void) {
        networkManager.cancelAll(completion: completion)
    }
    
    private func makeRequest(request: RequestBuilder,
                             completion: @escaping (Result<[MovieData], Error>) -> Void) {
        networkManager.request(urlRequest: request) { [weak self] data, response, error in
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
            guard let moviesResponce = decodeMessage(data: data, type: MoviesResponce.self)
            else {
                completion(.failure(BaseError.unableToDecodeData))
                return
            }
            self?.handleMoviesData(moviesResponce: moviesResponce,
                                   completion: completion)
        }
    }
    
    private func handleMoviesData(moviesResponce: MoviesResponce,
                                  completion: @escaping (Result<[MovieData], Error>) -> Void) {
        guard let movies = moviesResponce.results
        else {
            if let error = moviesResponce.errorMessage {
                MoviesError.errorMessage = error
                completion(.failure(MoviesError.errorFromServer))
            } else {
                completion(.failure(BaseError.unableToDecodeData))
            }
            return
        }
        completion(.success(movies))
    }
    
    private func buildRequest(expression: String) -> RequestBuilder? {
        let finalPath = path + expression
        var urlComponents = baseURLComponents
        urlComponents.path = finalPath
        guard let url = urlComponents.url
        else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.method = HTTPMethod.get
        urlRequest.setValue(NetworkConfiguration.Headers.contentTypeJSON.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.contentTypeJSON.field)
        urlRequest.setValue(NetworkConfiguration.Headers.acceptJSON.value,
                            forHTTPHeaderField: NetworkConfiguration.Headers.acceptJSON.field)
        return RequestBuilder(urlRequest: urlRequest)
    }
}
