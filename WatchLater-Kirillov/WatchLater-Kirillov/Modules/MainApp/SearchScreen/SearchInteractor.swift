//
//  SearchInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchInteractorProtocol {
    var isSearching: Bool { get }
    
    func cancelCurrentTask(expression: String,
                           completion: @escaping () -> Void)
    func searchMoviesIMDB(expression: String)
    func searchMoviesLocal(expression: String)
}

class SearchInteractor: SearchInteractorProtocol {
    
    private let searchService: SearchMovieServiceProtocol
    private let presenter: SearchPresenterProtocol
    
    var isSearching: Bool {
        return searchService.isSearching
    }
    
    init(presenter: SearchPresenterProtocol,
         searchService: SearchMovieServiceProtocol) {
        self.searchService = searchService
        self.presenter = presenter
    }
    
    func cancelCurrentTask(expression: String,
                           completion: @escaping () -> Void) {
        searchService.cancelPreviousRequest(expression: expression,
                                            completion: completion)
    }
    
    func searchMoviesIMDB(expression: String) {
        searchService.searchMovies(expression: expression) { [weak self] result in
            switch result {
            case .success(let movies):
                print(movies)
                self?.presenter.proceedMoviesData(movies: movies, for: .IMDB)
            
            case .failure(let error):
                print(error.localizedDescription)
                if let error = error as? BaseError,
                   error == .cancelled {
                    self?.presenter.showFailedStateIMDB(isSearching: true)
                } else {
                    self?.presenter.showFailedStateIMDB(isSearching: false)
                }
            }
        }
    }
    
    func searchMoviesLocal(expression: String) {
        FilmInfo.fetchMoviesWith(
            title: expression,
            fetchLimit: 50
        ) { [weak self] result in
            switch result {
            case .success(let filmsInfo):
                var movies = [MovieData]()
                movies.reserveCapacity(filmsInfo.count)
                for film in filmsInfo {
                    movies.append(MovieData(coreDataType: film))
                }
                self?.presenter.proceedMoviesData(movies: movies, for: .local)
                
            case .failure(let error):
                print("searchMoviesLocal - \(error.localizedDescription)")
                self?.presenter.showFailedStateLocal()
            }
        }
    }
}
