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
    
    init(viewController: DetailsViewController) {
        self.viewController = viewController
    }
    
    func presentEditViewController(navigationController: UINavigationController,
                                   movieDetails: MovieDetails) {
        let editMovieVC = EditMovieConfigurator().setupModule(movieDetails: movieDetails,
                                                              detailsViewController: viewController)
        navigationController.pushViewController(editMovieVC, animated: true)
    }
}
