//
//  FavouriteRouter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class FavouriteRouter {
    
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func pushSearchViewController(to navigationController: UINavigationController,
                                  animated: Bool = true) {
        navigationController.pushViewController(SearchScreenConfigurator().setupModule(), animated: animated)
    }
    
    func pushDetailsViewController(to navigationController: UINavigationController,
                                   film: FilmData,
                                   animated: Bool = true) {
        navigationController.pushViewController(DetailsScreenConfigurator().setupModule(imdbData: nil,
                                                                                        localData: film),
                                                animated: animated)
    }
}
