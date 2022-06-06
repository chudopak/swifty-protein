//
//  SearchRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class SearchRouter {
 
    private weak var viewController: SearchViewController!
    
    init(viewController: SearchViewController) {
        self.viewController = viewController
    }
    
    func presentDetailsViewController(navigationController: UINavigationController,
                                      imdbData: MovieData?,
                                      localData: FilmData?,
                                      screenVCDelegate: FilmInfoChangedInformerDelegate) {
        let detailsViewController = DetailsScreenConfigurator().setupModule(
            imdbData: imdbData,
            localData: localData,
            previousViewController: screenVCDelegate
        )
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
