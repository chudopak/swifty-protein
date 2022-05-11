//
//  DetailsPresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol DetailsPresenterProtocol {
    func sendPosterToView(result: Result<UIImage, Error>)
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    private weak var viewController: DetailsViewControllerProtocol!
    
    init(viewController: DetailsViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func sendPosterToView(result: Result<UIImage, Error>) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.setPoster(result: result)
        }
    }
}
