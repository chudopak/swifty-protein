//
//  FavouritePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouritePresenterProtocol {
    func presentMovies(films: [FilmInfoTmp]?)
}

class FavouritePresenter: FavouritePresenterProtocol {
    
    private weak var favouriteViewController: FavouriteViewControllerProtocol!
    
    init(viewController: FavouriteViewControllerProtocol) {
        favouriteViewController = viewController
    }
    
    func presentMovies(films: [FilmInfoTmp]?) {
        favouriteViewController.showFilms(films)
    }
}
