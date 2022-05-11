//
//  DetailsScreenConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class DetailsScreenConfigurator {
    
    func setupModule(imdbData: MovieData?,
                     localData: FilmInfoTmp?) -> DetailsViewController {
        let vc = DetailsViewController()
        let presenter = DetailsPresenter(viewController: vc)
        let imageService = ImageDownloadingService(networkManager: NetworkLayer(refreshService: RefreshTokenService()))
        let interactor = DetailsInteractor(presenter: presenter,
                                           imageDownloadingService: imageService)
        vc.setupData(imdbData: imdbData, localData: localData)
        vc.setupComponents(interactor: interactor)
        return vc
    }
}
