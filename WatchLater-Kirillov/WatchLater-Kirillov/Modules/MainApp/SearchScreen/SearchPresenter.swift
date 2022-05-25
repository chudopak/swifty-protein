//
//  SearchPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchPresenterProtocol {
    func proceedMoviesData(movies: [MovieData], for searchArea: SearchArea)
    func showFailedStateIMDB(isSearching: Bool)
    func showFailedStateLocal()
}

class SearchPresenter: SearchPresenterProtocol {
    
    private weak var viewController: SearchViewControllerProtocol!
    
    init(viewController: SearchViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func proceedMoviesData(movies: [MovieData], for searchArea: SearchArea) {
        DispatchQueue.main.async { [weak self] in
            if searchArea == .IMDB {
                self?.viewController.displayIMDBMovies(movies: movies)
            } else {
                self?.viewController.displayLocalMovies(movies: movies)
            }
        }
    }
    
    func showFailedStateIMDB(isSearching: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.showFailedStateIMDB(isSearching: isSearching)
        }
    }
    
    func showFailedStateLocal() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.showFailedStateLocal()
        }
    }
}
