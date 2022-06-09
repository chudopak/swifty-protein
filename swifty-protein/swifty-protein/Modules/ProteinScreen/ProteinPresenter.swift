//
//  ProteinPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

protocol ProteinPresenterProtocol {
}

final class ProteinPresenter: ProteinPresenterProtocol {
    
    private weak var viewController: ProteinViewControllerProtocol!
    private let ligandsService: LigandsServiceProtocol
    
    init(viewController: ProteinViewControllerProtocol,
         ligandsService: LigandsServiceProtocol) {
        self.viewController = viewController
        self.ligandsService = ligandsService
    }
}
