//
//  SearchInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchInteractorProtocol {
    func cancelCurrentTask(expression: String,
                           completion: @escaping () -> Void)
    func searchMoviesIMDB(expression: String)
}

class SearchInteractor: SearchInteractorProtocol {
    
    private let searchService: SearchMovieServiceProtocol
    private let presenter: SearchPresenterProtocol
    
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
                self?.presenter.proceedMoviesData(movies: movies)
            
            case .failure(let error):
                print(error.localizedDescription)
                if let error = error as? BaseError,
                   error == .cancelled {
                    self?.presenter.showFailedState(isSearching: true)
                } else {
                    self?.presenter.showFailedState(isSearching: false)
                }
            }
        }
    }
}
