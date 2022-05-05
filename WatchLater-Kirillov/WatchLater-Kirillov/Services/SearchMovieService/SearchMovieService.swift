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
    
    let groupMovies = DispatchGroup()
    private var moviesIds: [String]?
    private let moviesIdsLock = NSLock()
    
    let ratingGroup = DispatchGroup()
    private var ratings: [String: Rating]?
    private let ratingsLock = NSLock()
    
    private var isSearchingMovies = false
    
    var isSearching: Bool {
        if isSearchingMovies || moviesIds != nil {
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
        if let ids = moviesIds {
            print("Cancel moviewss !!!!!!!!!!!!!!!!")
            for id in ids {
                if let request = buildRequest(expression: id, path: self.ratingPath),
                   let url = request.urlRequest.url {
                    groupMovies.enter()
                    networkManager.cancel(by: url) { [weak self] in
                        self?.groupMovies.leave()
                    }
                }
            }
            groupMovies.notify(queue: DispatchQueue.main) { [weak self] in
                print("WE in group notify")
                self?.moviesIdsLock.lock()
                self?.moviesIds = nil
                self?.moviesIdsLock.unlock()
                completion()
            }
        } else {
            guard let request = buildRequest(expression: expression, path: searchPath),
                  let url = request.urlRequest.url
            else {
                print("SearchMovieService,cancelPreviousRequest - Can't build request")
                completion()
                return
            }
            networkManager.cancel(by: url, completion: completion)
        }
    }
    
    func searchMovies(expression: String,
                      completion: @escaping (Result<[MovieData], Error>) -> Void) {
        guard let request = buildRequest(expression: expression, path: searchPath)
        else {
            completion(.failure(BaseError.failedToBuildRequest))
            return
        }
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
                    if let baseError = error as? AFError,
                       let errorCode = baseError.underlyingError as? URLError,
                       errorCode.code == .cancelled {
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
        fillMoviesIds(movies: movies)
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
    
    private func fillMoviesIds(movies: [MovieData]) {
        moviesIdsLock.lock()
        moviesIds = [String]()
        moviesIds!.reserveCapacity(movies.count)
        for i in 0..<movies.count {
            moviesIds!.append(movies[i].id)
        }
        moviesIdsLock.unlock()
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
        moviesIdsLock.lock()
        moviesIds = nil
        moviesIdsLock.unlock()
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
