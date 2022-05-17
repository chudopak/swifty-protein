//
//  SearchRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class SearchRouter: FilmDataRouterProtocol {
 
    private weak var viewController: SearchViewController!
    
    init(viewController: SearchViewController) {
        self.viewController = viewController
    }
    
    func presentDetailsViewController(navigationController: UINavigationController,
                                      imdbData: MovieData?,
                                      localData: FilmData?) {
        let detailsViewController = DetailsScreenConfigurator().setupModule(
            imdbData: imdbData,
            localData: localData,
            previousScreenRouter: self
        )
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    func routFilmData(data: EditedFilmInfo) {
        // There is Nothing ToDO for now but maybe i can send that this film was added to core data
    }
}
