//
//  SearchPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchPresenterProtocol {
    func proceedMoviesData(movies: [MovieData])
}

class SearchPresenter: SearchPresenterProtocol {
    
    private weak var viewController: SearchViewControllerProtocol!
    
    init(viewController: SearchViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func proceedMoviesData(movies: [MovieData]) {
        viewController.displayMovies(movies: movies)
    }
}
