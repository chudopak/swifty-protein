//
//  FavouritePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouritePresenterProtocol {
    func presentWillWatchMovies()
    func presentViewedMovies()
}

class FavouritePresenter: FavouritePresenterProtocol {
    
    private weak var favouriteViewController: FavouriteViewControllerProtocol!
    
    init(viewController: FavouriteViewControllerProtocol) {
        favouriteViewController = viewController
    }
    
    func presentWillWatchMovies() {
    }
    
    func presentViewedMovies() {
    }
}
