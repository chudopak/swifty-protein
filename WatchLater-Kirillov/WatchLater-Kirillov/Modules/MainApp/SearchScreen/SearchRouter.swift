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
    
    func presentDetailsViewController(navigationController: UINavigationController) {
        let detailsViewController = DetailsScreenConfigurator().setupModule()
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
