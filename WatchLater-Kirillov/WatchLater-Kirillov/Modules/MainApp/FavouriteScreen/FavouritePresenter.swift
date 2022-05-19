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
    func replaceLastPage(films: [FilmData]?, watched: Bool, startReplacePosition: Int)
    func replaceMovie(film: [FilmData]?, watched: Bool, at position: Int)
    func addOneMovieToLastPage(film: [FilmData]?, watched: Bool)
    func setFilmsListOccupancy(watched: Bool, isFull: Bool)
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
    
    func replaceLastPage(films: [FilmData]?, watched: Bool, startReplacePosition: Int) {
        guard let films = films
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.replacePageWithBackendFilms(films, watched: watched, startReplacePosition: startReplacePosition)
        }
    }
    
    func replaceMovie(film: [FilmData]?, watched: Bool, at position: Int) {
        guard let films = film,
              let movie = films.first
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.replaceFilm(movie, watched: watched, at: position)
        }
    }
    
    func addOneMovieToLastPage(film: [FilmData]?, watched: Bool) {
        guard let films = film,
              let movie = films.first
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.appendOneFilm(movie, toList: watched)
        }
    }
    
    func setFilmsListOccupancy(watched: Bool, isFull: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.favouriteViewController.setFilmsListOccupancy(watched: watched, isFull: isFull)
        }
    }
}
