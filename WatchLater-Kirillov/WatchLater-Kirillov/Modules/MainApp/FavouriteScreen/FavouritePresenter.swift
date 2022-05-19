//
//  FavouritePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouritePresenterProtocol {
    func presentMovies(films: [FilmInfoTmp]?, watched: Bool)
    func compareMoviesWithCurrent(films: [FilmInfoTmp]?, watched: Bool)
}

class FavouritePresenter: FavouritePresenterProtocol {
    
    private weak var favouriteViewController: FavouriteViewControllerProtocol!
    
    init(viewController: FavouriteViewControllerProtocol) {
        favouriteViewController = viewController
    }
    
    func presentMovies(films: [FilmInfoTmp]?, watched: Bool) {
        guard var films = films
        else {
            favouriteViewController.showFilms(nil, watched: watched)
            return
        }
        for i in 0..<films.count {
            films[i].isWatched = watched
        }
        favouriteViewController.showFilms(films, watched: watched)
    }
    
    func compareMoviesWithCurrent(films: [FilmInfoTmp]?, watched: Bool) {
        guard var films = films
        else {
            favouriteViewController.checkMoviesForChanges(nil, watched: watched)
            return
        }
        for i in 0..<films.count {
            films[i].isWatched = watched
        }
        favouriteViewController.checkMoviesForChanges(films, watched: watched)
    }
}