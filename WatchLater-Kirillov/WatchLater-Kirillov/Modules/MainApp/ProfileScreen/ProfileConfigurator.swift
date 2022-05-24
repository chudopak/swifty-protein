//
//  ProfileConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class ProfileConfigurator {
    
    func setupModule() -> ProfileViewController {
        let vc = ProfileViewController()
        let router = ProfileRouter(viewController: vc)
        let presenter = ProfilePresenter(viewController: vc)
        let networkLayer = NetworkLayer(refreshService: RefreshTokenService())
        let imageService = ImageDownloadingService(networkManager: networkLayer)
        let interactor = ProfileInteractor(presenter: presenter,
                                           imageService: imageService)
        vc.setupComponents(router: router,
                           interactor: interactor)
        return vc
    }
}
