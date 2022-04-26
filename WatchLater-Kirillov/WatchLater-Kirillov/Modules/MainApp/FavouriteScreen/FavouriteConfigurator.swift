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
        let interactor = FavouriteInteractor(presenter: presenter)
        viewController.setupComponents(interactor: interactor)
        return viewController
    }
}
