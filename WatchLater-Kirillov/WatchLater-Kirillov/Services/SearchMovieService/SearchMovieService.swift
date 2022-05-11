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
    var isSearching: Bool { get }
    
    func searchMovies(expression: String,
                      completion: @escaping (Result<[MovieData], Error>) -> Void)
    func cancelPreviousRequest(expression: String,
                               completion: @escaping () -> Void)
}

class SearchMovieService: SearchMovieServiceProtocol {
    
    private let searchPath = "/API/SearchMovie/\(IMDBNetworkConfiguration.APIKey)/"
    private let ratingPath = "/API/Ratings/\(IMDBNetworkConfiguration.APIKey)/"
    
    let ratingGroup = DispatchGroup()
    private var ratings: [String: Rating]?
    private let ratingsLock = NSLock()
    
    private var isSearchingMovies = false
    
    var isSearching: Bool {
        if isSearchingMovies {
            return true
        } else {
            return false
        }
    }
    
    private var baseURLComponents: URLComponents
    
    private let networkManager: NetworkLayerProtocol
    
    init(networkManager: NetworkLayerProtocol) {
        self.networkManager = networkManager
        baseURLComponents = URLComponents()
        baseURLComponents.scheme = IMDBNetworkConfiguration.sceme
        baseURLComponents.host = IMDBNetworkConfiguration.urlString
    }
    
    func cancelPreviousRequest(expression: String,
                               completion: @escaping () -> Void) {
        networkManager.cancelAll {
            completion()
        }
    }
    
    func searchMovies(expression: String,
                      completion: @escaping (Result<[MovieData], Error>) -> Void) {
        guard let request = buildRequest(expression: expression, path: searchPath)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
        // TODO: Remove this print
        print(request.urlRequest.url!)
        makeRequest(request: request,
                    completion: completion)
    }
    
    private func makeRequest(request: RequestBuilder,
                             completion: @escaping (Result<[MovieData], Error>) -> Void) {
        isSearchingMovies = true
        networkManager.request(urlRequest: request) { [weak self] data, response, error in
            self?.isSearchingMovies = false
            guard error == nil,
                  let responseHTTP = response as? HTTPURLResponse,
                  responseHTTP.statusCode == 200,
                  let data = data
            else {
                if let error = error {
                    if let isCancelled = self?.isRequestExplisitlyCancelled(error: error),
                       isCancelled {
                        completion(.failure(BaseError.cancelled))
                    } else {
                        completion(.failure(error))
                    }
                } else if data == nil {
                    completion(.failure(BaseError.noData))
                } else {
                    completion(.failure(BaseError.range400Response))
                }
                return
            }
            self?.handleMoviesData(data: data,
                                   completion: completion)
        }
    }
    
    private func isRequestExplisitlyCancelled(error: Error) -> Bool {
        if let baseError = error as? AFError {
            if baseError.isExplicitlyCancelledError {
                return true
            } else if let errorCode = baseError.underlyingError as? URLError,
                      errorCode.code == .cancelled {
                return true
            }
            return false
        }
        return false
    }
    
    private func handleMoviesData(data: Data,
                                  completion: @escaping (Result<[MovieData], Error>) -> Void) {
        guard let moviesResponce = decodeMessage(data: data, type: MoviesResponce.self)
        else {
            completion(.failure(BaseError.unableToDecodeData))
            return
        }
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
//        fetchRating(movies: movies, completion: completion)
    }
    
    private func fetchRating(movies: [MovieData],
                             completion: @escaping (Result<[MovieData], Error>) -> Void) {
        for movie in movies {
            if let request = buildRequest(expression: movie.id, path: self.ratingPath) {
                ratingGroup.enter()
                networkManager.request(urlRequest: request) { [weak self] data, response, error in
                    guard error == nil,
                          let responseHTTP = response as? HTTPURLResponse,
                          responseHTTP.statusCode == 200,
                          let data = data
                    else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        self?.ratingGroup.leave()
                        return
                    }
                    guard let rating = decodeMessage(data: data, type: Rating.self)
                    else {
                        self?.ratingGroup.leave()
                        return
                    }
                    self?.handleRatingValidation(rating: rating)
                    self?.ratingGroup.leave()
                }
            }
        }
        ratingGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.notifyCompletion(movies: movies,
                                   completion: completion)
        }
    }
    
    private func handleRatingValidation(rating: Rating) {
        if rating.imDbId != nil {
            ratingsLock.lock()
            if ratings == nil {
                ratings = [String: Rating]()
            }
            ratings![rating.imDbId!] = rating
            ratingsLock.unlock()
        }
    }
    
    private func notifyCompletion(movies: [MovieData],
                                  completion: @escaping (Result<[MovieData], Error>) -> Void) {
        print("We in NOTIFY")
        if let ratings = ratings {
            var moviesData = movies
            for i in 0..<moviesData.count {
                if let rating = ratings[moviesData[i].id]?.imDb {
                    moviesData[i].rating = rating
                }
                if let year = ratings[moviesData[i].id]?.year {
                    moviesData[i].year = year
                }
            }
            self.ratingsLock.lock()
            self.ratings = nil
            self.ratingsLock.unlock()
            completion(.success(moviesData))
        } else {
            completion(.success(movies))
        }
    }
    
    private func buildRequest(expression: String, path: String) -> RequestBuilder? {
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
