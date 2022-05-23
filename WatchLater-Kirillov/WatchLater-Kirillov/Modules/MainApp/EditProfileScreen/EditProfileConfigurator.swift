//
//  EditProfileConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class EditProfileConfigurator {
    
    func setupModule() -> EditProfileViewController {
        let vc = EditProfileViewController()
        let router = EditProfileRouter(viewController: vc)
        let presenter = EditProfilePresenter(viewController: vc)
        let networkService = NetworkLayer(refreshService: RefreshTokenService())
        let imageService = ImageDownloadingService(networkManager: networkService)
        let interactor = EditProfileInteractor(presenter: presenter,
                                               imageDownloadingService: imageService)
        vc.setupComponents(router: router, interactor: interactor)
        return vc
    }
}
