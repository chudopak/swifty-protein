//
//  FavouritePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouritePresenterProtocol {
    func presentMovies(films: [FilmData]?, watched: Bool)
    func compareMoviesWithCurrent(films: [FilmData]?, watched: Bool)
    func replaceLastPage(films: [FilmData]?, watched: Bool)
}

class FavouritePresenter: FavouritePresenterProtocol {
    
    private weak var favouriteViewController: FavouriteViewControllerProtocol!
    
    init(viewController: FavouriteViewControllerProtocol) {
        favouriteViewController = viewController
    }
    
    func presentMovies(films: [FilmData]?, watched: Bool) {
        guard let films = films
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.showFilms(films, watched: watched)
        }
    }
    
    func compareMoviesWithCurrent(films: [FilmData]?, watched: Bool) {
        guard let films = films
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.checkMoviesForChanges(films, watched: watched)
        }
    }
    
    func replaceLastPage(films: [FilmData]?, watched: Bool) {
        guard let films = films
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.replacePageWithBackendFilms(films, watched: watched)
        }
    }
}
