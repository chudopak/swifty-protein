//
//  FavouriteRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FilmDataRouterProtocol {
    func routFilmData(data: EditedFilmInfo)
}

final class FavouriteRouter: FilmDataRouterProtocol {
    
    private weak var viewController: FavouriteViewController!
    
    init(viewController: FavouriteViewController) {
        self.viewController = viewController
    }
    
    func pushSearchViewController(to navigationController: UINavigationController,
                                  animated: Bool = true) {
        navigationController.pushViewController(
            SearchScreenConfigurator().setupModule(),
            animated: animated
        )
    }
    
    func pushDetailsViewController(to navigationController: UINavigationController,
                                   film: FilmData,
                                   animated: Bool = true) {
        navigationController.pushViewController(
            DetailsScreenConfigurator().setupModule(
                    imdbData: nil,
                    localData: film,
                    previousScreenRouter: self
            ),
            animated: animated
        )
    }
    
    func routFilmData(data: EditedFilmInfo) {
        switch data {
        case .cangedWatchStatus(let data):
            viewController.cangeFilmInfo(filmData: data)
            
        case .deleted(let id):
            viewController.handleDeletedFilm(id: id)
        }
    }
}
