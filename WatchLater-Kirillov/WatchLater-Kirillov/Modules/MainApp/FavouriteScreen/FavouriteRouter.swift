//
//  FavouriteRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class FavouriteRouter {
    
    private weak var viewController: FavouriteViewController!
    
    init(viewController: FavouriteViewController) {
        self.viewController = viewController
    }
    
    func pushSearchViewController(
        to navigationController: UINavigationController,
        animated: Bool = true,
        favouriteVCDelegate: FilmInfoChangedInformerDelegate
    ) {
        navigationController.pushViewController(
            SearchScreenConfigurator().setupModule(filmChangedDelegate: favouriteVCDelegate),
            animated: animated
        )
    }
    
    func pushDetailsViewController(
        to navigationController: UINavigationController,
        film: FilmData,
        favouriteVCDelegate: FilmInfoChangedInformerDelegate,
        animated: Bool = true
    ) {
        navigationController.pushViewController(
            DetailsScreenConfigurator().setupModule(
                    movieData: nil,
                    filmData: film,
                    previousViewController: favouriteVCDelegate
            ),
            animated: animated
        )
    }
}
