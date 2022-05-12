//
//  EditMovieRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class EditMovieRouter {
    
    private weak var editMovieVC: EditMovieViewController!
    private weak var detailsViewControllerDelegate: DetailsViewControllerDelegate!
    
    init(viewController: EditMovieViewController,
         detailsViewController: DetailsViewControllerDelegate) {
        self.editMovieVC = viewController
        self.detailsViewControllerDelegate = detailsViewController
    }
    
    func sendMovieDetailsToDetailsScreen(movieDetails: MovieDetails,
                                         navigationController: UINavigationController) {
        detailsViewControllerDelegate.setMovieDetailsAfterEditing(movieDetails: movieDetails)
        navigationController.popViewController(animated: true)
    }
}
