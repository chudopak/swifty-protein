//
//  FavouriteInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouriteInteractorProtocol {
    func fetchMovies(page: Int, size: Int, watched: Bool)
}

class FavouriteInteractor: FavouriteInteractorProtocol {
    
    private let presenter: FavouritePresenterProtocol
    private let networkService: FetchFilmsServiceProtocol
    
    init(presenter: FavouritePresenterProtocol, networkService: FetchFilmsServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func fetchMovies(page: Int, size: Int, watched: Bool) {
        networkService.fetchFilms(page: page, size: size, watched: watched) { [weak self] result in
            switch result {
            case .success(let films):
                self?.presenter.presentMovies(films: films)
                
            case .failure(let error):
                print("Fetch Movies error - \(error.localizedDescription)")
            }
        }
    }
}
