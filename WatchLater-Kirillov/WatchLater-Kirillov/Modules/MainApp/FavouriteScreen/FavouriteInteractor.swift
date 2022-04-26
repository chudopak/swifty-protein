//
//  FavouriteInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouriteInteractorProtocol {
    func fetchViewedMovies()
    func fetchWillWatchMovies()
}

class FavouriteInteractor: FavouriteInteractorProtocol {
    
    private let presenter: FavouritePresenterProtocol
    
    init(presenter: FavouritePresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchViewedMovies() {
    }
    
    func fetchWillWatchMovies() {
    }
}
