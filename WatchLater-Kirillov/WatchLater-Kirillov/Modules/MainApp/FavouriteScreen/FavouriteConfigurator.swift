//
//  FavouriteConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class FavouriteConfigurator {
    
    func setupModule() -> FavouriteViewController {
        let viewController = FavouriteViewController()
        let presenter = FavouritePresenter(viewController: viewController)
        let filmsService = FetchFilmsService(networkLayer: NetworkLayer(refreshService: RefreshTokenService()))
        let interactor = FavouriteInteractor(presenter: presenter,
                                             networkService: filmsService)
        let router = FavouriteRouter(viewController: viewController)
        viewController.setupComponents(interactor: interactor,
                                       router: router)
        return viewController
    }
}
