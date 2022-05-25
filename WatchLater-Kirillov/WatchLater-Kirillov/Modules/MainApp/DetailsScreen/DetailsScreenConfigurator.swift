//
//  DetailsScreenConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class DetailsScreenConfigurator {
    
    func setupModule(movieData: MovieData?,
                     filmData: FilmData?,
                     previousViewController: FilmInfoChangedInformerDelegate) -> DetailsViewController {
        let vc = DetailsViewController()
        let presenter = DetailsPresenter(viewController: vc)
        let imageService = ImageDownloadingService(networkManager: NetworkLayer(refreshService: RefreshTokenService()))
        let filmsService = FetchFilmsService(networkLayer: NetworkLayer(refreshService: RefreshTokenService()))
        let interactor = DetailsInteractor(presenter: presenter,
                                           imageDownloadingService: imageService,
                                           filmsService: filmsService)
        let router = DetailsRouter(viewController: vc)
        vc.setupData(movieData: movieData,
                     filmData: filmData)
        vc.setupComponents(interactor: interactor,
                           router: router,
                           previousVCDelegate: previousViewController)
        return vc
    }
}
