//
//  DetailsRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class DetailsRouter {
    
    private weak var viewController: DetailsViewController!
    private let previousScreenRouter: FilmDataRouterProtocol
    
    init(viewController: DetailsViewController,
         previousScreenRouter: FilmDataRouterProtocol) {
        self.viewController = viewController
        self.previousScreenRouter = previousScreenRouter
    }
    
    func presentEditViewController(navigationController: UINavigationController,
                                   movieDetails: MovieDetails) {
        let editMovieVC = EditMovieConfigurator().setupModule(movieDetails: movieDetails,
                                                              detailsViewController: viewController)
        navigationController.pushViewController(editMovieVC, animated: true)
    }
    
    func sendMovieInfoToPreviousScreen(state: EditedFilmInfo) {
        previousScreenRouter.routFilmData(data: state)
    }
    
    func presentPreviousViewController(navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
}
