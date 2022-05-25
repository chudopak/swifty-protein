//
//  SearchScreenConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/29/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class SearchScreenConfigurator {
    
    func setupModule(filmChangedDelegate: FilmInfoChangedInformerDelegate) -> SearchViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter(viewController: viewController)
        let searchService = SearchMovieService(networkManager: NetworkLayer(refreshService: RefreshTokenService()))
        let interactor = SearchInteractor(presenter: presenter,
                                          searchService: searchService)
        let router = SearchRouter(viewController: viewController)
        viewController.setupComponents(interactor: interactor,
                                       router: router,
                                       filmChangedDelegate: filmChangedDelegate)
        return viewController
    }
}
