//
//  EditMovieConfigurator.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class EditMovieConfigurator {
    
    func setupModule(movieDetails: MovieDetails,
                     detailsViewController: DetailsViewControllerDelegate) -> EditMovieViewController {
        let vc = EditMovieViewController()
        let router = EditMovieRouter(viewController: vc,
                                     detailsViewController: detailsViewController)
        vc.setupMovieData(data: movieDetails)
        vc.setupComponents(router: router)
        return vc
    }
}
